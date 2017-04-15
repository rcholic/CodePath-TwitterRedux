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
            tweetView.tweet = twt
            tweetView.delegate = self
        }        
    }
}

extension TweetDetailViewController: TweetViewDelegate {
    
    func tweetView(_ tweetView: TweetView, didTap: TweetViewButtonType) {
        // assign tweet to tweetView:
//        tweetView.tweet = //
        switch didTap {
        case .reply:
            print("hit reply button")
        case .favorite:

            if let tweet = tweetView.tweet, let tweetId = tweet.id {
                TwitterClient.shared.toggle(favorite: !tweet.isFavorited, tweetId: tweetId, params: nil, completion: { (tweet, error) in
                    
                    print("received toggled tweet: \(tweet)")
                    tweetView.tweet = tweet // update tweet in the view
                })
            }

        default:
            // retweet as default
            if let tweet = tweetView.tweet, let tweetId = tweet.id {
                TwitterClient.shared.retweet(tweetId: tweetId, toRetweet: !tweet.isRetweeted, params: nil, completion: { (tweet, error) in
                    print("received retweeted tweet: \(tweet)")
                    tweetView.tweet = tweet // update tweet
                })
            }
        }
    }
}
