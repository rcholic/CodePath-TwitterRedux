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

@objc protocol TweetCellDelegate: class {
    @objc func tweetCell(cell: TweetCell, didTap profileImageView: UIImageView, with tweet: Tweet)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var authoProfileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var authorScreenLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
    internal var tweet: Tweet! {
        didSet {
            self.bind(tweet)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        authoProfileImageView.layer.cornerRadius = 3.0
        authoProfileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.didTapOnProfileImageView(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        authoProfileImageView.addGestureRecognizer(tapGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func didTapOnProfileImageView(tapGesture: UITapGestureRecognizer) {
        delegate?.tweetCell(cell: self, didTap: self.authoProfileImageView, with: self.tweet)
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
//                print("tweetedAt: \(createdAt))")
                let now = Date().toTimezone(TimeZoneEnum.utc, dateFormat: TWT_DATE_FORMAT)
                timeAgoLabel.text = "\(now.timeSince(createdAt))"
            }
        }
    }
}
