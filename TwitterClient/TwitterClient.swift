//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twittercConsumerKey = "PWCc8DMAYyEETbZRBtm6UcpzL"
let twitterConsumerSecret = "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3"
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    public static let shared = TwitterClient(url: twitterBaseURL!, consumerKey: twittercConsumerKey, consumerSecret: twitterConsumerSecret)
    
    let url: URL
    let key: String
    let secret: String
    
    private init(url: URL!, consumerKey: String!, consumerSecret: String!) {
        self.url = url
        self.key = consumerKey
        self.secret = consumerKey
        
        super.init(baseURL: url, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
