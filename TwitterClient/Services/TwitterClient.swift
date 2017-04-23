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

// authorizing requests: https://dev.twitter.com/oauth/overview/authorizing-requests

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    public static let shared = TwitterClient(url: TWT_BASE_URL, consumerKey: TWT_CONSUMER_KEY, consumerSecret: TWT_CONSUMER_SECRET)
    
    private let url: URL
    private let key: String
    private let secret: String
    
    private var accessToken: String {
        get {
            guard let token = DataManager.shared.retrieve(for: DataKey.accessToken) else { return "" }
//            print("saved access token: \(token)")
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
    internal func getHomeTimeLine(maxId: Int64? = nil, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error?) -> Void) {
        var params : [String : Any] = ["count": 20]
        if let max = maxId {
            params["max_id"] = max
        }
        
        get("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation, response) in
            print("response: \(response)")
            
            let json = JSON(response)
            var results: [Tweet] = []
            if let tweets = Mapper<Tweet>().mapArray(JSONObject: json.arrayObject) {
                results = tweets
            }
            
            success(results)
            
        }) { (failedOperation, error) in
            
            failure(error)
        }
    }
    
    internal func toggle(favorite: Bool, tweetId: Int64, params: [String: Any]?, completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> Void) {
        let endpoint = favorite ? "create" : "destroy"
        // e.g. 1.1/favorites/create.json?id=243138128959913986
        post("1.1/favorites/\(endpoint).json?id=\(tweetId)", parameters: params, success: { (operation, response) in
            
            let tweet = Mapper<Tweet>().map(JSON: JSON(response).dictionaryObject!)
            completion(tweet, nil)
            
        }) { (failedOperation, error) in
            completion(nil, error)
            print("error in favorite: \(error)")
        }
    }
    
    internal func retweet(tweetId: Int64, toRetweet: Bool, params: [String: Any]?, completion: @escaping (_ tweet: Tweet?, _ error: Error?) -> Void) {
        
        let endpoint = toRetweet ? "retweet" : "unretweet"
        post("1.1/statuses/\(endpoint)/\(tweetId).json", parameters: params, success: { [weak self] (operation, response) in
            
            let tweet = Mapper<Tweet>().map(JSON: JSON(response).dictionaryObject!)

            completion(tweet, nil)

            //            // refetch the old tweet that has been just retweeted
//            self?.fetchTweet(id: tweetId, params: nil, success: { (retweeted) in
//                
//                completion(retweeted, nil)
//                
//            }, failure: { (error) in
//                print("error from retweet")
//            })
            
            
        }) { (failedOperation, error) in
            completion(nil, error)
            print("error in favorite: \(error)")
        }
    }
    
    internal func fetchTweet(id: Int64, params: [String : Any]?, success: @escaping (Tweet?) -> Void, failure: @escaping (Error?) -> Void) {
        
        get("1.1/statuses/show.json?id=\(id)", parameters: params, success: { (operation, response) in
            
            let tweet = Mapper<Tweet>().map(JSON: JSON(response).dictionaryObject!)
            success(tweet)
            
        }) { (failedOperation, error) in
            failure(error)
        }
    }
    
    // reference: https://dev.twitter.com/rest/reference/post/statuses/update
    internal func sendTweet(text: String, replyTo: Tweet?, success: @escaping (Tweet?) -> ()) {

        guard text.characters.count > 0 else {
            return
        }
        var params : [String : Any] = ["status": text]

        if let tweet = replyTo, let author = tweet.author {
            print("replying to user id: \(author.id)")
            params["in_reply_to_screen_name"] = author.screenName
            params["in_reply_to_status_id"] = tweet.id
            params["in_reply_to_user_id"] = author.id
        }

        post("1.1/statuses/update.json", parameters: params, success: { (operation, response) -> Void in
            let tweet = Mapper<Tweet>().map(JSON: JSON(response).dictionaryObject!)
            success(tweet)
        })
    }
    
    // reference to user timeline: https://dev.twitter.com/rest/reference/get/statuses/user_timeline
    
    // MARK: screenName: the screen name of the user for whom to return results for; count: max number of tweets to fetch
    internal func getTimelinesFor(screenName: String? = nil, count: Int? = 200, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error?) -> Void) {
        
        var targetUrl = "1.1/statuses/user_timeline.json?"
        if screenName != nil {
            targetUrl += "screen_name=\(screenName!)&"
        }
        if count != nil {
            targetUrl += "count=\(count!)"
        }
        
        get(targetUrl, parameters: nil, success: { (operation, response) in
//            print("user timelines response: \(response)")
            let json = JSON(response)
            var results: [Tweet] = []
            
            if let tweets = Mapper<Tweet>().mapArray(JSONObject: json.arrayObject) {
                results = tweets
            }

            // 
//            var updatedUser: TwitterUser? = nil // get the user's most updated info e.g. tweets count.
//            if let res = response as? [String: Any] {
//                print("user profile? \(res["user"])")
//            }
//            print("user in timelines1: \(json["user"].dictionary)")
//            print("user in timelines2: \(json["user"].dictionaryObject)")
//            print("user in timelines3: \(json["user"].dictionaryValue)")
//            if let user = Mapper<TwitterUser>().map(JSONObject: json["user"].dictionaryObject) {
//                print("updated user background image: \(user.profileBackgroundImageUrl)")
//            }
            success(results)
            
        }) { (failedOperation, error) in
            
            failure(error)
        }
    }
    
}
