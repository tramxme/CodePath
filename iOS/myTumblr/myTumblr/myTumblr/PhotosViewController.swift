//
//  PhotosViewController.swift
//  myTumblr
//
//  Created by Tram Lai on 5/11/17.
//  Copyright © 2017 Tram Lai. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl : UIRefreshControl!
    var isMoreDataLoading = false  //Flag to check if the app has already made a request to the server
    var loadingMoreView: InfiniteScrollActivityView?
    
    var posts : [Any]?
    var offset = 20 //Each time you request, Tumblr API only gives you 20 posts, you need to keep track of the offset so you can get more
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest()
        
        //Initiate a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Images...")
        refreshControl.addTarget(self, action: #selector(networkRequest), for: UIControlEvents.valueChanged)
        //Add refreshControl to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    func networkRequest(){
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! NSDictionary
                
                self.posts = responseDictionary["posts"] as? [Any]
                
                //Reload the table view
                self.tableView.reloadData()
                
                //Tell the refresher to stop spinning
                self.refreshControl.endRefreshing()
            }
        }
        print("number of posts are: ")
        print(self.posts?.count)
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let posts = posts{
            return posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let post = posts?[indexPath.row] as! [String: Any]
        if let photos = post["photos"] as? [Any]{
            // photos is NOT nil, we can use it!
            let photo = photos[0] as! [String: Any]
            let original_size = photo["original_size"] as! [String: Any]
            
            let photoUrl = original_size["url"] as! String
            let url = URL(string: photoUrl)
            
            cell.photoView.af_setImage(withURL: url!)
        }
        print(indexPath.row)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PhotoDetailViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
    
        let cell = tableView.cellForRow(at: indexPath!) as! PhotoCell
        
        destination.newImage = cell.photoView.image
    }
    
    //Remove the gray selection effect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            
            //Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Load more results
                loadMoreData()
            }
        }
    }

    //Request to load more data
    func loadMoreData(){
        // Configure session so that completion handler is executed on main UI thread
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV" + "&offset=" + String(offset))!
        offset += 20
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task = session.dataTask(with: url) { (data, response, error) in
            //update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            //Use the new data to update the data source
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let responseDictionary = dataDictionary["response"] as! NSDictionary
                let additionalPosts = responseDictionary["posts"] as? [Any]
            
                //I'm not sure why I can't just do self.posts.append(additionalPosts)
                for res in additionalPosts!{
                    self.posts?.append(res)
                }
             }
            
            //Reload the table view
            self.tableView.reloadData()
            }
        task.resume()
    }
}
