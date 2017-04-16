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
    
    var replyToTweet: Tweet?
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var authorNambeLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        profileImageView.layer.cornerRadius = 3.0
        curUser = DataManager.shared.getCurUser() // check for nil
        
        if let user = curUser {
            if let imageURL = user.profileImgUrl {
                profileImageView.setImageWith(imageURL)
            }
            authorNambeLabel.text = user.name ?? "no name"
        }
        
        if let replyTo = replyToTweet {
            tweetButton.setTitle("Reply", for: .normal)
        }
        
        // textView
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.masksToBounds = true
        
        textView.delegate = self
        
        // hide character count label:
        characterCountLabel.isHidden = true
        tweetButton.isEnabled = false // disabled at loaded
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {

        TwitterClient.shared.sendTweet(text: textView.text, replyTo: replyToTweet) { [weak self] (updatedTweet) in
            print("successfully created/updated tweet: \(updatedTweet)")
            // TODO: throw a toastr for success confirmation
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension ComposeTweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.isHidden = textView.text.characters.count == 0
        tweetButton.isEnabled = textView.text.characters.count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let remaining = TWT_CHARACTERS_LIMIT - textView.text.characters.count - text.characters.count - range.length
        characterCountLabel.text = "Remaining Characters: \(remaining)"
        
        return textView.text.characters.count + (text.characters.count - range.length) <= TWT_CHARACTERS_LIMIT

    }

}
