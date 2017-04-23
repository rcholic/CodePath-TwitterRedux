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

class ProfileViewController: UIViewController, TweetListViewDelegate {
    
    @IBOutlet weak var profileBgImageView: UIImageView!
    @IBOutlet weak var profileAvatarImageView: UIImageView!
    @IBOutlet weak var tweetListView: TweetListView!
    @IBOutlet weak var profileFullname: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
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
}
