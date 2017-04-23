//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/22/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
    // left margin constraint for the content view
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!

    // top margin constraint for the content view
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuTopMarginConstraint: NSLayoutConstraint!
    
    private (set) var originalLeftMargin: CGFloat!
    
    private var composeButton: UIBarButtonItem!
    
    private let contentViewOffset: CGFloat = 90
    
    var menuViewController: UIViewController! {
        didSet(oldViewController) {
            view.layoutIfNeeded() // trigger the view controller life cycle
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentVC) {
            if oldContentVC != nil {
                // clean up the old contentVC
                oldContentVC.willMove(toParentViewController: nil)
                oldContentVC.view.removeFromSuperview()
                oldContentVC.didMove(toParentViewController: nil)
            }
            
            view.layoutIfNeeded()
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            self.title = contentViewController.title ?? "" // update navbar title
            UIView.animate(withDuration: 0.3) {
                self.leftMarginConstraint.constant = 0 // show the content ful screen
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTopMarginConstraint.constant = NAVBAR_HEIGHT
        topMarginConstraint.constant = NAVBAR_HEIGHT
        contentView.addGestureRecognizer(panGesture)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        composeButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.presentTweetView(sender:)))
        composeButton.setFAText(prefixText: "", icon: FAType.FATwitter, postfixText: " Tweet", size: 17)
        navigationItem.rightBarButtonItem = composeButton
    }
    
    private func checkLoginStatus() {
        
        if TwitterClient.shared.isSignedIn() {
            composeButton.isEnabled = true
            if let timelineVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController {
                self.contentViewController = timelineVC
            }
        } else {
            composeButton.isEnabled = false
            if let onboardVC = mainStoryBoard.instantiateViewController(withIdentifier: "OnboardVC") as? OnboardViewController {
                self.contentViewController = onboardVC
            }
        }
    }
    
    @objc private func presentTweetView(sender: UIBarButtonItem) {
        if let tweetVC = mainStoryBoard.instantiateViewController(withIdentifier: "ComposeBoard") as? ComposeTweetViewController {
//            self.contentViewController = tweetVC
            // TODO: what if reply to a tweet?
            self.navigationController?.pushViewController(tweetVC, animated: true)
        }
    }
    
    @objc private func onPanGesture(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if gesture.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if gesture.state == .changed {
            // update left margin of the content view
            
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    // open menu
                    self.leftMarginConstraint.constant = self.view.bounds.size.width - self.contentViewOffset
                } else {
                    self.leftMarginConstraint.constant = 0 // closing
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
    internal func present(_ viewcontroller: UIViewController) {
        self.contentViewController = viewcontroller
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.onPanGesture(gesture:)))
        
        return gesture
    }()
}
