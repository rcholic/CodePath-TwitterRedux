//
//  ViewController.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

import OAuthSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTwitter()
      //  login()
    }
    
    private func loginTwitter() {
        TwitterClient.shared.requestSerializer.removeAccessToken()
        TwitterClient.shared.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "swifty-oauth://oauth-callback/twitter")!, scope: "scopetest", success: { (requestToken: BDBOAuth1Credential?) in
            print("token: \(requestToken?.token)")
        }) { (error: Error?) in
            print("error: \(error)")
        }
    }
    
    /*
     <key>TwitterKey</key>
     <string>PWCc8DMAYyEETbZRBtm6UcpzL</string>
     <key>TwitterSecret</key>
     <string>h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3</string>
     <key>TwitterBaseUrl</key>
     <string>https://api.twitter.com</string>
     */
    private func login() {
        // using OAuthSwift: https://github.com/OAuthSwift/OAuthSwift
      //  let oauthSwift = OAuth2Swift(consumerKey: "PWCc8DMAYyEETbZRBtm6UcpzL", consumerSecret: "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3", authorizeUrl: "https://api.twitter.com/oauth/authorize", accessTokenUrl: "https://api.twitter.com/oauth/access_token", responseType: "token")
        
        let oauth1Swift = OAuth1Swift(consumerKey: "PWCc8DMAYyEETbZRBtm6UcpzL", consumerSecret: "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3", requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                                      authorizeUrl:    "https://api.twitter.com/oauth/authorize",
                                      accessTokenUrl:  "https://api.twitter.com/oauth/access_token")
        
        let handle = oauth1Swift.authorize(
            withCallbackURL: URL(string: "swifty-oauth://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print("token: \(credential.oauthToken)")
                print("token secret: \(credential.oauthTokenSecret)")
                print("user id: \(parameters["user_id"])")
        },
            failure: { error in
                print(error.localizedDescription)
        }             
        )
    }
    
}

