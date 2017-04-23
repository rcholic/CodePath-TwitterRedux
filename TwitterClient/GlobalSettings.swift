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
    case requestToken = "RequestToken"
    case accessToken = "AccessToken"
    case lastLogin = "LastLogin"
}

public let TWITTER_CALLBACK_URL = "swifty-oauth://oauth-callback/twitter"

public let OAUTH_SCHEME_ID = "swifty-oauth"

public let TWT_CONSUMER_KEY = "PWCc8DMAYyEETbZRBtm6UcpzL"

public let TWT_CONSUMER_SECRET = "h5WG1TfkGS0QGNDK3dyLEe3GchBMWZqPivPIucAESPJrTlItw3"

public let TWT_BASE_HTTP_PATH = "https://api.twitter.com"

public let TWT_BASE_URL = URL(string: TWT_BASE_HTTP_PATH)!

public let inactiveTint = UIColor.gray

public let TWT_CHARACTERS_LIMIT: Int = 140

public let NAVBAR_HEIGHT: CGFloat = 60

public let TWT_DATE_FORMAT = "EEE MMM d HH:mm:ss Z y"

public let TWITTER_BLUE: UIColor = UIColor.init(red: 0/255.0, green: 132/225.0, blue: 180/255.0, alpha: 1.0)

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//public let activeTint = // self.tintColor
