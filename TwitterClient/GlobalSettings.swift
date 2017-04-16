//
//  GlobalSettings.swift
//  TwitterClient
//
//  Created by Wang, Tony on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import Foundation

internal enum DataKey: String {
    case twitterUser = "TwitterUser"
//    case screenName = "ScreenName"
    case requestToken = "RequestToken"
    case accessToken = "AccessToken"
    case lastLogin = "LastLogin"
}

public let TWITTER_CALLBACK_URL = "swifty-oauth://oauth-callback/twitter"

public let OAUTH_SCHEME_ID = "swifty-oauth"

public let TWT_CONSUMER_KEY = "PWCc8DMAYyEETbZRBtm6UcpzL"

public let TWT_CONSUMER_SECRET = "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3"

public let TWT_BASE_URL = URL(string: "https://api.twitter.com")!

public let inactiveTint = UIColor.gray

public let TWT_CHARACTERS_LIMIT = 140

//public let activeTint = // self.tintColor
