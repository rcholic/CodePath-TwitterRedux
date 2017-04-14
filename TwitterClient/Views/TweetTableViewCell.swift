//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    internal var tweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(tweetView)
        tweetView.clipsToBounds = true
        tweetView.frame = self.contentView.bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private lazy var tweetView: TweetView = {
        let view = TweetView(tweet: self.tweet)        
        return view
    }()
    
}
