//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet var tweetView: TweetView!
    internal var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let twt = tweet {
            self.tweetView.tweet = twt
        }        
    }
}
