//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import AFNetworking
import ObjectMapper

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var authoProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var authorScreenLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    internal var tweet: Tweet! {
        didSet {
            self.bind(tweet)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        authoProfileImageView.layer.cornerRadius = 3.0        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func bind(_ twt: Tweet) {
        if let author = twt.author {
            if let profileImageUrl = author.profileImgUrl {
                authoProfileImageView.setImageWith(profileImageUrl)
            }
            
            authorScreenLabel.text = "@\(author.screenName ?? "no_s_name")"
            authorNameLabel.text = author.name ?? "no_name"
            tweetTextLabel.text = twt.text ?? "no content"
            
            if let createdAt = twt.createdAt {
                print("tweetedAt: \(createdAt))")
                let now = Date().toTimezone(TimeZoneEnum.utc, dateFormat: TWT_DATE_FORMAT)
                timeAgoLabel.text = "\(now.timeSince(createdAt))"
            }
        }
    }
}
