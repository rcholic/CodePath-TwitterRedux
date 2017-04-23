//
//  MenuTableViewController.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/22/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellId = "MenuCell"
    private var menuVC : [String : UIViewController] = [:]
    private var menus: [String] = []
    internal (set) var hamburgerVC: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //        tableView.backgroundColor = TWITTER_BLUE
        //        tableView.tintColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240.0
        tableView.tableFooterView = UIView() // no empty cells
        
        populateMenuVCs()
    }
    
    private func populateMenuVCs() {
        // profile, timeline, mentions, accounts
//        let onboardVC = mainStoryBoard.instantiateViewController(withIdentifier: "OnboardVC") as! OnboardViewController
        let profileVC = mainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
  
        let timelineVC = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        
        let mentionsVC = mainStoryBoard.instantiateViewController(withIdentifier: "MentionsVC") as! MentionsViewController
        
        let accountsVC = mainStoryBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsViewController
        
        menuVC["Profile"] = profileVC
        menuVC["Timeline"] = timelineVC
        menuVC["Mentions"] = mentionsVC
        menuVC["Accounts"] = accountsVC
        
        menus = Array<String>(menuVC.keys)
//        tableView.reloadData()
        
        hamburgerVC.contentViewController = timelineVC // default to timelineVC
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = menus[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vcName = menus[indexPath.row]
        
        hamburgerVC.contentViewController = menuVC[vcName] // show the targetVC in the content view
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
