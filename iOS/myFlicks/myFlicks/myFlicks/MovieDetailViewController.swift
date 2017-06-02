//
//  MovieDetailViewController.swift
//  myFlicks
//
//  Created by Tram Lai on 5/26/17.
//  Copyright © 2017 Tram Lai. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var movie:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        // Do any additional setup after loading the view.
        if let poster_path = movie?["poster_path"] as? String {
            let base_url = "https://image.tmdb.org/t/p/w500/"
            let posterURL = URL(string: base_url + poster_path)!
            posterImageView.setImageWith(posterURL)
        } else {
            // No poster image. Can either set to nil (no image) or a default movie poster image that you include as an asset
            posterImageView.image = nil
        }

        titleLabel.text = movie?["title"] as! String?
        titleLabel.sizeToFit()
        overviewLabel.text = movie?["overview"] as! String?
        overviewLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
