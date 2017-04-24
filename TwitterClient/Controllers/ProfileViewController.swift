//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/22/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class ProfileViewController: UIViewController, TweetListViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var profileBgImageView: UIImageView!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    @IBOutlet weak var tweetListView: TweetListView!
    @IBOutlet weak var profileFullname: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    @IBOutlet weak var scrollViewContainer: UIView!    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
//    TODO: get the user's updated profile?
    
    var author: TwitterUser? = nil
    
    var curUser: TwitterUser? = nil {
        didSet {
            if let user = curUser {
                // hook up the views
                self.loadTimelinesFor(user)
                if let bgImageUrl = user.profileBackgroundImageUrl {
                    profileBgImageView.setImageWith(bgImageUrl)
                } else {
                    profileBgImageView.image = UIImage(named: "defaultBackground")
                }
                if let avatarImageUrl = user.profileImgUrl {
                    profileAvatarImageView.setImageWith(avatarImageUrl)
                }

                profileFullname.text = user.name ?? "John Doe"
                screenNameLabel.text = "@\(user.screenName ?? "johndoe")"
                followersCountLabel.text = "\(user.followersCount)"
                followingCountLabel.text = "\(user.followingCount)"
                tweetsCountLabel.text = "\(user.tweetsCount)"
            }
        }
    }
    
    private var timelines: [Tweet] = [] {
        didSet {
            tweetListView.tweets = timelines
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initPhase2()
        setupScrollview()
    }
    
    private func initPhase2() {
        title = "Profile"
        if author != nil {
            curUser = author!
        } else {
            curUser = DataManager.shared.getCurUser()
        }
        profileAvatarImageView.layer.cornerRadius = 3.0
        profileAvatarImageView.layer.borderWidth = 2.0
        profileAvatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        tweetListView.delegate = self
    }
    
    private func setupScrollview() {

        let scrollViewHeight = scrollView.frame.size.height
        let scrollViewWidth = scrollView.frame.size.width
        scrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight) // set the content size
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        textView.frame = CGRect(origin: scrollView.frame.origin, size: CGSize(width: scrollViewWidth, height: scrollViewHeight))
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.text = curUser?.tagline ?? "This is a sample description of the user"
        textView.textColor = .black
        pageControl.currentPage = 0
    }
    
    private func loadTimelinesFor(_ user: TwitterUser, _ callback: (() -> Void)? = nil) {
        let username = user.name ?? user.screenName
        
        SVProgressHUD.showInfo(withStatus: "Loading \(username)'s Tweets For You)")        
        TwitterClient.shared.getTimelinesFor(screenName: user.screenName, count: 200, success: { (tweets) in

            DispatchQueue.main.async {
                self.timelines = tweets
                if let cb = callback {
                    cb() // trigger the callback
                }
                SVProgressHUD.dismiss()
            }
        }, failure: { (error) in
            print("error in getting user's timeline: \(error)")
        })
    }
    
    func tweetListView(_ tweetListView: TweetListView, didSelect tweet: Tweet) {
        if let tweetDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "TweetDetailVC") as? TweetDetailViewController {
            tweetDetailVC.tweet = tweet
//            hamburgerVC.present(tweetDetailVC)
//            hamburgerVC.navigationController?.pushViewController(tweetDetailVC, animated: true)
            present(tweetDetailVC, animated: true, completion: nil)
        }
    }
    
    func tweetListView(_ tweetListView: TweetListView, didRefresh: Bool, callback: @escaping () -> Void) {
        if didRefresh, let user = curUser {
            loadTimelinesFor(user, callback)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width // Test the offset and calculate the current page after scrolling ends
        let currengPage: CGFloat = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1
        // change the indicator
        pageControl.currentPage = Int(currengPage)
        
        if Int(currengPage) == 0 {
            textView.text = curUser?.tagline ?? "Sample Tag Line for users without description"
        } else if Int(currengPage) == 1 {
            textView.text = "Second Page of Sample Tagline!"
        }
        
        
    }
}
