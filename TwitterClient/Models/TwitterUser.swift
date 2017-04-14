//
//  TwitterUser.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//
import ObjectMapper

class TwitterUser: BaseJsonModel {
    
    var name: String?
    var screenName: String?
    var profileImgUrl: URL?
    var tagline: String?
    var followersCount: Int? = 0
    var aboutMeUrl: URL?
    var location: String?
    
    override func mapping(map: Map) {
        name <- map["name"]
        screenName <- map["screen_name"]
        profileImgUrl <- (map["profile_image_url"], URLTransform()) // profile_image_url_https
        tagline <- map["description"]
        followersCount <- map["followers_count"]
        aboutMeUrl <- (map["url"], URLTransform())
        location <- map["location"]
    }
}
