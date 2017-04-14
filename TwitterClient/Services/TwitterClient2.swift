//
//  TwitterClient2.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import OAuthSwift

internal struct TwitterClient2 {
    
    private var oauthSwift: OAuth1Swift!
    
    public static var shared = TwitterClient2(consumerKey: TWT_CONSUMER_KEY, consumerSecret: TWT_CONSUMER_SECRET)
    
    private init(consumerKey: String, consumerSecret: String) {
        
        oauthSwift = OAuth1Swift(
            consumerKey:    consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
    }
    
    internal func login() {
        
        _ = oauthSwift.authorize(
            withCallbackURL: URL(string: TWITTER_CALLBACK_URL)!,
            success: { credential, response, parameters in
                print("success: \(credential.oauthToken)")
            }, failure: { error in
                print("error: \(error.description)")
            }
        )
    }
    
    internal func logout() {
        
    }
}
