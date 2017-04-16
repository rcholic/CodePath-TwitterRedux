//
//  TweetCell2.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/16/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

class TweetCell2: UITableViewCell {
    
    internal var tweet: Tweet! {
        didSet {
            tweetView.tweet = tweet
            tweetView.setNeedsLayout()
            tweetView.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(tweetView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetView.frame = self.contentView.bounds
        tweetView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private lazy var tweetView: TweetView = {
        let view = TweetView()
        //        view.delegate = self
        return view
    }()    
}
