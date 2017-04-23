//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class TweetDetailViewController: UIViewController, TweetViewDelegate {

    @IBOutlet var tweetView: TweetView!
    @IBOutlet weak var closeButton: UIButton!
    
    internal var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        self.view.bringSubview(toFront: closeButton)
        closeButton.setFAIcon(icon: FAType.FAWindowClose, forState: UIControlState.normal)
        
        if let twt = tweet {
            tweetView.tweet = twt // use twt as temporary placeholder
            tweetView.delegate = self
            
            // pull the tweet for the latest update
            populateTweet(id: twt.id)
        }        
    }
    
    private func populateTweet(id: Int64?) {
        guard let tweetId = id else { return }
        TwitterClient.shared.fetchTweet(id: tweetId, params: nil, success: { [weak self] (tweet) in
            self?.tweet = tweet
            self?.tweetView.tweet = tweet // update with the latest download
        }) { (error) in
            NSLog("error: \(error)")
        }
    }
    
    
    @IBAction func didTapCloseBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tweetView(_ tweetView: TweetView, didTap: TweetViewButtonType) {
        
        switch didTap {
        case .reply:
            if let targetVC = storyboard?.instantiateViewController(withIdentifier: "ComposeBoard") as? ComposeTweetViewController {
                
                targetVC.replyToTweet = self.tweet // passed as a tweet replying to
                targetVC.modalPresentationStyle = .custom
                                targetVC.transitioningDelegate = self
                
                // TODO: should be placed inside UIPresentationController
//                self.view.addSubview(backdrop)
//                UIView.animate(withDuration: 0.2, animations: { 
//                    self.backdrop.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
//                })
                present(targetVC, animated: true, completion: nil)
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
                    tweetView.tweet = tweet // update tweet
                })
            }
        }
    }
    
    fileprivate lazy var backdrop: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/3.0))
        view.backgroundColor = UIColor.gray.withAlphaComponent(0)

        return view
    }()
}

extension TweetDetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return smallerSizedPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // configure the presented view controller to a smaller window
    internal class smallerSizedPresentationController: UIPresentationController {
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 2.0))

        override func presentationTransitionWillBegin() {
            
            borderView.backgroundColor = TWITTER_BLUE
            self.presentedView?.addSubview(borderView)
            self.presentedView?.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1)
            
            // TODO: insert backdrop shadow to the top 1/3 of the container view
//            containerView?.insertSubview(backdrop, at: 0)
//            print("presenting the view controller")
//            backdrop.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT/3)
//            containerView?.insertSubview(backdrop, at: 0)
        }
        
        override func dismissalTransitionWillBegin() {
//            print("dismissing the view controller")
            borderView.removeFromSuperview()
        }
        
        override var frameOfPresentedViewInContainerView: CGRect {
            return CGRect(x: 0, y: SCREEN_HEIGHT/3, width: SCREEN_WIDTH, height: 2 * SCREEN_HEIGHT/3.0)
        }
    }
}
