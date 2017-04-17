//
//  OnboardViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/16/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import Font_Awesome_Swift

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.tintColor = UIColor.white
        loginButton.setFAText(prefixText: "Signin with Twitter  ", icon: FAType.FATwitter, postfixText: "", size: 25, forState: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        
        if TwitterClient.shared.isSignedIn() {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        
        TwitterClient.shared.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: TWITTER_CALLBACK_URL)!,
            scope: "scopetest",
            success: { [weak self] (requestToken: BDBOAuth1Credential?) in
                
                if let token = requestToken?.token {
                    
                    let url = URL(string: "\(TWT_BASE_HTTP_PATH)/oauth/authorize?oauth_token=\(token)")!
                    UIApplication.shared.openURL(url)
                    
                }
        }) { (error: Error?) in
            print("error: \(error)")
        }
    }
}
