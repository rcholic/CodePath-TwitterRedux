//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/12/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
//import Alamofire
import ObjectMapper
import SwiftyJSON

// example: https://github.com/tejen/codepath-twitter/blob/master/Twitter/Twitter/TwitterClient.swift
// assignment: https://courses.codepath.com/courses/intro_to_ios/unit/3#!assignment

class HomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let refreshControl = UIRefreshControl()
    let cellIdentifier = "TweetCell"
    
    var curUser: TwitterUser? = nil
    var tweets: [Tweet] = []
    
    private var isLoggedIn: Bool = false {
        didSet {
            if isLoggedIn {
                self.loginButton.title = "Logout"
                
                if let lastLogin = DataManager.shared.retrieve(for: DataKey.lastLogin) as? Date {
                    print("last login: \(lastLogin)")
                }
                
            } else {
                self.loginButton.title = "Login"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPhase2()
        setupView()
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(self.didTapGetTweets(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView() // don't show empty cells
        
        let cellNib = UINib(nibName: "TweetCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func initPhase2() {
        isLoggedIn = TwitterClient.shared.isSignedIn()
        if let userJsonStr = DataManager.shared.retrieve(for: DataKey.twitterUser) as? String {
            curUser = Mapper<TwitterUser>().map(JSONString: userJsonStr)
//            print("curUser: \(curUser?.name)")
        }
    }
    
    @IBAction func didTapGetTweets(_ sender: Any) {
        TwitterClient.shared.getHomeTimeLine(success: { (tweets) in
//            print("received tweets: \(tweets)")
            self.refreshControl.endRefreshing()
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print("error: \(error)")
        }
        
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        
        if TwitterClient.shared.isSignedIn() {
            // log out
            TwitterClient.shared.requestSerializer.removeAccessToken()
            TwitterClient.shared.deauthorize()
            _ = DataManager.shared.delete(key: DataKey.accessToken)
            isLoggedIn = false
        } else {
            
//            TwitterClient2.shared.login()
            
            // login user
            TwitterClient.shared.fetchRequestToken(
                withPath: "oauth/request_token",
                method: "GET",
                callbackURL: URL(string: "swifty-oauth://oauth-callback/twitter")!,
                scope: "scopetest",
                success: { (requestToken: BDBOAuth1Credential?) in
                    
                print("token: \(requestToken?.token)")
                if let token = requestToken?.token {
                    let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                    UIApplication.shared.openURL(url)
                    self.isLoggedIn = true
                }
            }) { (error: Error?) in
                print("error: \(error)")
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select row: \(indexPath.row)")
        
        if let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "TweetDetailVC") as? TweetDetailViewController {
            targetVC.tweet = tweets[indexPath.row]
            self.navigationController?.pushViewController(targetVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
