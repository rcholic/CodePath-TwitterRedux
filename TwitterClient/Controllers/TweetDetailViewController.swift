//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    internal var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let twt = tweet {
            let tweetView = TweetView(tweet: twt)
            self.view.addSubview(tweetView)
            tweetView.frame = self.view.bounds
        }        
    }
}
