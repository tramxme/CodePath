//
//  MoviesViewController.swift
//  myFlicks
//
//  Created by Tram Lai on 5/12/17.
//  Copyright © 2017 Tram Lai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var refreshControl : UIRefreshControl!
    var filteredMovies : [NSDictionary]? = []
    
    var endpoint: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self

        refreshControlAction()
        
        //Adding Pull-to-Refresh
        //Initialize a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Movies...")
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        
        //Add refresh control to tableview
        collectionView.insertSubview(self.refreshControl, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshControlAction() {
        //Loading data from the network
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil{
                if let data = data {
                    if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        //print(dataDictionary)
                        
                        //Hide HUD once the network request come back (must be done on the main UI thread)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.movies = dataDictionary["results"] as? [NSDictionary]
                        self.filteredMovies = self.movies!
                        
                        //Reload every time making network request
                        self.collectionView.reloadData()
                        
                        //Tell the refreshControl to stop spinning
                        self.refreshControl.endRefreshing()
                    }
                }
            }else{
                print("This is a network error: ")
                print(error)
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredMovies = movies!
        }else{
            filteredMovies = []
            for movie in movies!{
                let title = movie["title"] as! String
                if (title.lowercased().contains(searchText.lowercased())){
                    filteredMovies?.append(movie)
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    //Called when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        collectionView.reloadData()
        searchBar.endEditing(true)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If movies is not nil
        if filteredMovies != nil{
            return filteredMovies!.count
        }
        return 0
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MovieCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies?[indexPath.row]
        
        if let poster_path = movie?["poster_path"] as? String {
            let base_url = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string: base_url + poster_path)!
            cell.posterView.setImageWith(posterURL)
        } else {
            // No poster image. Can either set to nil (no image) or a default movie poster image that you include as an asset
            cell.posterView.image = nil
        }
        return cell
    }

 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor .gray
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        let destination = segue.destination as! MovieDetailViewController
        let indexPath = collectionView.indexPath(for: cell)
        let movie = filteredMovies?[(indexPath?.row)!]
        
        destination.movie = movie!
    }
}
