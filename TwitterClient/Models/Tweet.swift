//
//  Tweet.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/12/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

//
//  Tweet.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/11/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//
import ObjectMapper

// https://dev.twitter.com/rest/reference/get/statuses/home_timeline
class Tweet: BaseJsonModel {
    
    var text: String?
    var createdAt: Date?
    var retweetCount: Int? = 0
    var isRetweeted: Bool = false
    var user: TwitterUser? = nil
    var favoritesCount: Int? = 0
    
    override func mapping(map: Map) {
        // TODO: date conversion
        
        //        let dateFormatter = DateFormatter()
        //        let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        //            dateFormatter.dateFormat = ""
        //            return dateFormatter.date(from: value!)
        //
        //        }) { (value: Date?) -> String? in
        //
        //            dateFormatter.dateFormat = ""
        //
        //            return dateFormatter.string(from: value!)
        //        }
        
        text <- map["text"]
        // "Wed Mar 03 19:37:35 +0000 2010"
        createdAt <- (map["created_at"], CustomDateFormatTransform(formatString: "EEE MM dd HH:mm:ss.ssZ YYYY")) // DateTransform()
        retweetCount <- map["retweet_count"]
        isRetweeted <- map["retweeted"]
        user <- map["user"]
        favoritesCount <- map["favourites_count"]
    }
    
    
    
}