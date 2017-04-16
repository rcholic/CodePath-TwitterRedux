//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/12/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import Font_Awesome_Swift
import ObjectMapper
import SwiftyJSON

// example: https://github.com/tejen/codepath-twitter/blob/master/Twitter/Twitter/TwitterClient.swift
// assignment: https://courses.codepath.com/courses/intro_to_ios/unit/3#!assignment

class HomeViewController: UIViewController {

    // TODO: distinguish infinite reload and drag to refresh: handle the array tweets differently!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let cellIdentifier = "TweetCell"
    fileprivate let cellNib = UINib(nibName: "TweetCell", bundle: Bundle.main)
    fileprivate var lowestTweetId: Int64? = nil
    fileprivate var isLoadingMoreTweets: Bool = false
    fileprivate var tweets: [Tweet] = []
    
    private var curUser: TwitterUser? = nil
    
    private var isLoggedIn: Bool = false {
        didSet {
            if isLoggedIn {
                self.loginButton.title = "Logout"
                self.composeButton.isEnabled = true
                if let lastLogin = DataManager.shared.retrieve(for: DataKey.lastLogin) as? Date {
                    print("last login: \(lastLogin)")
                }
                
            } else {
                self.composeButton.isEnabled = false
                self.loginButton.title = "Login"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPhase2()
        loadTweets(maxId: nil)
    }
    
    private func initPhase2() {
        
        composeButton.setFAIcon(icon: FAType.FATwitter, iconSize: 25)
        
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(self.refreshTweets(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView() // don't show empty cells
        
        
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        isLoggedIn = TwitterClient.shared.isSignedIn()
        curUser = DataManager.shared.getCurUser()
    }
    
    @objc private func refreshTweets(_ sender: Any) {
        loadTweets(maxId: nil)
    }
    
    fileprivate func loadTweets(maxId: Int64?) {
        if maxId == nil {
            tweets.removeAll() // remove all the items, if any
        }
        
        TwitterClient.shared.getHomeTimeLine(maxId: maxId, success: { [weak self] (tweets) in
            self?.isLoadingMoreTweets = false
            self?.refreshControl.endRefreshing()
            self?.tweets += tweets
            self?.tableView.reloadData()
            self?.lowestTweetId = tweets.map {
                return $0.id as Int64!
                }.min()
            print("lowestTweetId: \(self?.lowestTweetId as Int64!)")
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
                callbackURL: URL(string: TWITTER_CALLBACK_URL)!,
                scope: "scopetest",
                success: { [weak self] (requestToken: BDBOAuth1Credential?) in
                    
                if let token = requestToken?.token {
                    
                    let url = URL(string: "\(TWT_BASE_HTTP_PATH)/oauth/authorize?oauth_token=\(token)")!
                    UIApplication.shared.openURL(url)
                    self?.isLoggedIn = true
                }
            }) { (error: Error?) in
                print("error: \(error)")
            }
        }
    }
    
    @IBAction func didTapTweetButton(_ sender: Any) {
        // prevent unauthenticated user from tweeting
        guard let _ = DataManager.shared.getCurUser() else { return }
        
        if let targetVC = storyboard?.instantiateViewController(withIdentifier: "ComposeBoard") as? ComposeTweetViewController {

            self.present(targetVC, animated: true, completion: nil)
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !isLoadingMoreTweets else { return }
        
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
            isLoadingMoreTweets = true
            if let lowestId = lowestTweetId as Int64! {
                lowestTweetId = lowestId - 1
            }
            loadTweets(maxId: lowestTweetId)
        }
    }
}
