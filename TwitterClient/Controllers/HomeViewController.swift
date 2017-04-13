//
//  HomeViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/12/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import Alamofire

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
        if let accessToken = DataManager.shared.retrieve(for: DataKey.accessToken) as? String {
            
            let headers = [
                "Authorization": "Basic \(accessToken)",
                "Accept": "application/json"
            ]
            Alamofire.request("https://api.twitter.com/1.1/statuses/home_timeline.json", headers: headers).responseJSON { response in
                print("response: \(response)")
            }
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
