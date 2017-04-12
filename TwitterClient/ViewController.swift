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
// issue: https://github.com/OAuthSwift/OAuthSwift/issues/156
class ViewController: UIViewController {
    
    let consumerKey = "PWCc8DMAYyEETbZRBtm6UcpzL"
    let consumerSecret = "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3"

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTwitter()
      //  login()
    }
    
    private func loginTwitter() {
        TwitterClient.shared.requestSerializer.removeAccessToken()
        TwitterClient.shared.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "swifty-oauth://oauth-callback/twitter")!, scope: "scopetest", success: { (requestToken: BDBOAuth1Credential?) in
            print("token: \(requestToken?.token)")
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.openURL(url)
            }
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
        
 
        
        let oauthswift = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )

        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "swifty-oauth://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print("success: \(credential.oauthToken)")
        },
            failure: { error in
                print("error: \(error.description)")
        }
        )
    }
    
}

