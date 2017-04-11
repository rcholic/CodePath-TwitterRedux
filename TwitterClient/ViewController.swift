//
//  ViewController.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTwitter()
    }
    
    private func loginTwitter() {
        TwitterClient.shared.requestSerializer.removeAccessToken()
        TwitterClient.shared.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "http://codepath.com/")!, scope: "scopetest", success: { (requestToken: BDBOAuth1Credential?) in
            print("token: \(requestToken)")
        }) { (error: Error?) in
            print("error: \(error)")
        }
    }
}

