//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    public static let shared = TwitterClient(url: TWT_BASE_URL, consumerKey: TWT_CONSUMER_KEY, consumerSecret: TWT_CONSUMER_SECRET)
    
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
    
    /*
    private lazy var twitterBaseURL: URL = {
        let baseUrl: String = DataManager.shared.retrieve(for: "TwitterBaseUrl") as? String ?? "https://api.twitter.com"
        return URL(string: baseUrl)!
    }()
    
    private lazy var twittercConsumerKey: String = {
        return DataManager.shared.retrieve(for: "TwitterKey") as? String ?? ""
    }()
    
    private lazy var twitterConsumerSecret: String = {
        return DataManager.shared.retrieve(for: "TwitterKey") as? String ?? ""
    }()
    */
}
