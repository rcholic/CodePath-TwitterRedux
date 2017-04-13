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

class HomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
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
    }
    
    private func initPhase2() {
        isLoggedIn = TwitterClient.shared.isSignedIn()
    }
    
    @IBAction func didTapGetTweets(_ sender: Any) {
        TwitterClient.shared.getHomeTimeLine(success: { (tweets) in
            print("received tweets: \(tweets)")
        }) { (error) in
            print("error: \(error)")
        }
        
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        
        if TwitterClient.shared.isSignedIn() {
            // log out
            TwitterClient.shared.requestSerializer.removeAccessToken()
            _ = DataManager.shared.delete(key: DataKey.accessToken)
            isLoggedIn = false
        } else {
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
