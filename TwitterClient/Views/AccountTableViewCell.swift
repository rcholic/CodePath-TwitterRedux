//
//  AccountTableViewCell.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/23/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol AccountTableViewCellDelegate: class {
    func accountTableViewCell(cell: AccountTableViewCell, swiped: Bool)
}

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    internal var account: TwitterUser! {
        didSet {
            avatarImageView.setImageWith(account.profileImgUrl!)
            screenameLabel.text = account.screenName!
            nameLabel.text = account.name!
        }
    }
    
    weak var delegate: AccountTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = TWITTER_BLUE
        screenameLabel.textColor = UIColor.white
        nameLabel.textColor = UIColor.white
    }
    
    private func addGesture() {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(self.didSwipe(sender:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func didSwipe(sender: UISwipeGestureRecognizer) {
        print("did swipe ...")
        delegate?.accountTableViewCell(cell: self, swiped: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
