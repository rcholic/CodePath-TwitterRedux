//
//  TweetView.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import AFNetworking

//typealias tweetviewDelegateCallback = (() -> Void)

@objc internal enum TweetViewButtonType: Int {
    case favorite
    case retweet
    case reply
}

@objc protocol TweetViewDelegate: class {
    @objc func tweetView(_ tweetView: TweetView, didTap: TweetViewButtonType) // , callback: tweetviewDelegateCallback?
}

@IBDesignable
class TweetView: UIView {
    
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet weak var autoNameLabel: UILabel!
    
    @IBOutlet weak var authorScreenLabel: UILabel!
    
    @IBOutlet weak var timeagoLabel: UILabel!    

    @IBOutlet var tweetTextLabel: UILabel!
    
    @IBOutlet var replyButton: UIButton!
    
    @IBOutlet var retweetButton: UIButton!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var retweetCountLabel: UILabel!
    
    @IBOutlet var favoriteCountLabel: UILabel!
    
    var view: UIView!
    
    weak var delegate: TweetViewDelegate?
    
    internal var tweet: Tweet? {
        didSet {
            bindContent(tweet)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
    }
    
    convenience init(tweet: Tweet) {
        self.init(frame: .zero)
        self.tweet = tweet
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
        initPhase2()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bindContent(tweet)
    }
    
    private func initPhase2() {
        xibSetup()
        translatesAutoresizingMaskIntoConstraints = false
        authorProfileImageView.layer.cornerRadius = 3.0
       // autoresizingMask = [.flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
    }
    
    private func bindContent(_ tweet: Tweet?) {
        
        guard let twt = tweet else { return }
        NSLog("binging tweet to the tweet view")
        if let author = twt.author {
            if let profileImageUrl = author.profileImgUrl {
                authorProfileImageView.setImageWith(profileImageUrl)
            }
            
            authorScreenLabel.text = "@\(author.screenName ?? "no_s_name")"
            autoNameLabel.text = author.name ?? "no_name"
            tweetTextLabel.text = twt.text ?? "no content"
            
            if let createdAt = twt.createdAt {
                let timeAgo = Date().timeSince(from: createdAt)
                timeagoLabel.text = "\(timeAgo)"
            }
        }
        if twt.isFavorited {
            favoriteButton.tintColor = tintColor
        } else {
            favoriteButton.tintColor = inactiveTint
        }
        
        if twt.isRetweeted {
            retweetButton.tintColor = tintColor
        } else {
            retweetButton.tintColor = inactiveTint
        }
        let retweetCountTxt = twt.retweetCount > 0 ? "(\(twt.retweetCount))" : ""
        retweetCountLabel.text = retweetCountTxt
        
        let favoriteCountTxt = twt.favoritesCount > 0 ? "(\(twt.favoritesCount))" : ""
        favoriteCountLabel.text = favoriteCountTxt
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "TweetView", bundle: Bundle.main)
        let curView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return curView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let textLabel = UILabel()
        textLabel.text = "Tweet View!"
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(textLabel)
        textLabel.frame = CGRect(x: 0, y: 0, width: (self.superview?.bounds.width)!, height: 50)
    }
    
    @IBAction func didTapReply(_ sender: Any) {
        delegate?.tweetView(self, didTap: TweetViewButtonType.reply)
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        delegate?.tweetView(self, didTap: TweetViewButtonType.retweet)
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        delegate?.tweetView(self, didTap: TweetViewButtonType.favorite)
    }
    
    
    
    
}
