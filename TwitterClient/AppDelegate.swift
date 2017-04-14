//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import OAuthSwift
import BDBOAuth1Manager
import SwiftyJSON
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        /*
         // for OAuthSwift
         
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
            return true
        }
        */
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.shared.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            if let token = accessToken?.token {
                _ = DataManager.shared.save(token, for: DataKey.accessToken)
                _ = DataManager.shared.save(Date(), for: DataKey.lastLogin) // last login date
            }
            
            TwitterClient.shared.retrieveCurrentUser(success: { (twtUser) in
                if let curUser = twtUser, let jsonStr = curUser.toJSONString() {
                    _ = DataManager.shared.save(jsonStr, for: DataKey.twitterUser)
                }
            }, failure: { (error) in
                print("error: \(error)")
            })
            
        }, failure: { (error: Error?) in
            print("error in getting access token: \(error)")
        })

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

