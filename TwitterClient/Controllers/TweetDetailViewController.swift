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
            tweetView.tweet = twt // use twt as temporary placeholder
            tweetView.delegate = self
            
            // pull the tweet for the latest update
            populateTweet(id: twt.id)
        }        
    }
    
    private func populateTweet(id: String?) {
        guard let tweetId = id else { return }
        TwitterClient.shared.fetchTweet(id: tweetId, params: nil, success: { [weak self] (tweet) in
            self?.tweet = tweet
            self?.tweetView.tweet = tweet // update with the latest download
        }) { (error) in
            print("error: \(error)")
        }
        
//        TwitterClient.shared.sendTweet(text: "hello world from iOS!", replyToId: id) { (publishedTweet) in
//            print("published tweet.id: \(publishedTweet?.id)")
//        }
    }
}

extension TweetDetailViewController: TweetViewDelegate {
    
    func tweetView(_ tweetView: TweetView, didTap: TweetViewButtonType) {

        switch didTap {
        case .reply:
            if let targetVC = storyboard?.instantiateViewController(withIdentifier: "ComposeBoard") as? ComposeTweetViewController {

                targetVC.replyToTweet = self.tweet // passed as a tweet replying to
                self.present(targetVC, animated: true, completion: nil)
            }
        case .favorite:

            if let tweet = tweetView.tweet, let tweetId = tweet.id {
                TwitterClient.shared.toggle(favorite: !tweet.isFavorited, tweetId: tweetId, params: nil, completion: { (tweet, error) in
//                    print("received favorite toggled tweet: \(tweet)")
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
