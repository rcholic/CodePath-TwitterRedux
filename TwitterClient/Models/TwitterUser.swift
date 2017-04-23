//
//  TwitterUser.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//
import ObjectMapper

class TwitterUser: BaseJsonModel {
    
    var id: Int64 = 0
    var name: String?
    var screenName: String?
    var profileImgUrl: URL?
    var profileBackgroundImageUrl: URL?
    var tagline: String?
    var followersCount: Int = 0
    var aboutMeUrl: URL?
    var location: String?
    var tweetsCount: Int = 0
    var favoritesCount: Int = 0
    var followingCount: Int = 0
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        screenName <- map["screen_name"]
        profileImgUrl <- (map["profile_image_url"], URLTransform())
        profileBackgroundImageUrl <- (map["profile_background_image_url"], URLTransform())
        tagline <- map["description"]
        followersCount <- map["followers_count"]
        aboutMeUrl <- (map["url"], URLTransform())
        location <- map["location"]
        tweetsCount <- map["statuses_count"]
        favoritesCount <- map["favourites_count"]
        followingCount <- map["friends_count"]
    }
    
    public override var description: String {
        return "author name: \(name), id: \(id) tagline: \(tagline)"
    }
}
