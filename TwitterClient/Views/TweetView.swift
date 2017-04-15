//
//  TweetView.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/13/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import AFNetworking

//import SnapKit

@IBDesignable
class TweetView: UIView {
    
    @IBOutlet weak var authorProfileImageView: UIImageView!
    
    @IBOutlet weak var autoNameLabel: UILabel!
    
    @IBOutlet weak var authorScreenLabel: UILabel!
    
    @IBOutlet weak var timeagoLabel: UILabel!    

    @IBOutlet var tweetTextLabel: UILabel!
    
    var view: UIView!
    
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
    
}
