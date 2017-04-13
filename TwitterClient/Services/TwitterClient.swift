//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import SwiftyJSON
import ObjectMapper

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    public static let shared = TwitterClient(url: TWT_BASE_URL, consumerKey: TWT_CONSUMER_KEY, consumerSecret: TWT_CONSUMER_SECRET)
    
    private let url: URL
    private let key: String
    private let secret: String
    
    private var accessToken: String {
        get {
            guard let token = DataManager.shared.retrieve(for: DataKey.accessToken) else { return "" }
            print("saved access token: \(token)")
            return token as! String
        }
    }
    
    private init(url: URL!, consumerKey: String!, consumerSecret: String!) {
        self.url = url
        self.key = consumerKey
        self.secret = consumerKey
        
        super.init(baseURL: url, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func isSignedIn() -> Bool {
        return accessToken.characters.count > 0
    }
    
    internal func retrieveCurrentUser(success: @escaping (TwitterUser?) -> Void, failure: @escaping (Error?) -> Void) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation, response) in
            let json = JSON(response)
            let twtUser = Mapper<TwitterUser>().map(JSON: json.dictionaryObject!)
            
            success(twtUser)
            
        }, failure: { (failedOperation: AFHTTPRequestOperation?, error: Error) in

            failure(error)
        })
        
    }
    
    // MARK: get home time lines
    internal func getHomeTimeLine(maxId: Int? = nil, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error?) -> Void) {
        var params = ["count": 10]
        if let max = maxId {
            params["max_id"] = max
        }
        
        get("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response) in
            print("response: \(response)")
            
            let json = JSON(response)
            var results: [Tweet] = []
            if let tweets = Mapper<Tweet>().mapArray(JSONObject: json.arrayObject) {
                for tweet in tweets {
                    print("tweet.user: \(tweet.user?.name)")
                    print("tweet created at: \(tweet.createdAt)")
                    results = tweets
                }
            }
            
            success(results)
            
        }) { (failedOperation, error) in
            
            failure(error)
        }
    }
    
}
