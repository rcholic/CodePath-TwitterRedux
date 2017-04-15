//
//  ComposeTweetViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/15/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import ObjectMapper
import AFNetworking

class ComposeTweetViewController: UIViewController {

    var curUser: TwitterUser?
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var authorNambeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curUser = DataManager.shared.getCurUser() // check for nil
        if let imageURL = curUser?.profileImgUrl {
            profileImageView.setImageWith(imageURL)
        }
        authorNambeLabel.text = curUser?.name ?? "no name"
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapTweet(_ sender: Any) {
        // TODO:
        didTapCancel(sender)
    }
    
    

}
