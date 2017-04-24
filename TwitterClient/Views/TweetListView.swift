//
//  TweetListView.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/23/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

@objc protocol TweetListViewDelegate: class {
    @objc func tweetListView(_ tweetListView: TweetListView, didSelect tweet: Tweet)
    @objc func tweetListView(_ tweetListView: TweetListView, didRefresh: Bool, callback: @escaping () -> Void)
}

@IBDesignable
class TweetListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // TODO: handle pull to refresh, infinite scroll ?
    
    private let tableView = UITableView()
    private let cellIdentifier = "TweetCell"
    private let cellNib = UINib(nibName: "TweetCell", bundle: Bundle.main)
    private let refreshControl = UIRefreshControl()
    
    internal var tweets: [Tweet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    weak var delegate: TweetListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    convenience init(tweets: [Tweet]) {
        self.init(frame: .zero)
        self.tweets = tweets
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func commontInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        self.addSubview(tableView)
        
        refreshControl.addTarget(self, action: #selector(self.refreshView(sender:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.frame = self.bounds
//        tableView.clipsToBounds = true
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tweetListView(self, didSelect: tweets[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true) // TODO: delegate this out of here?
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
//        cell.layoutIfNeeded()

        // FIXME: cell content view got its right border cut off
        
        return cell
    }
    
    internal func appendTweets(_ tweets: [Tweet]?) {
        
        guard let twts = tweets else { return }
        self.tweets.append(contentsOf: twts)
        tableView.reloadData()
    }
    
    @objc private func refreshView(sender: UIRefreshControl) {
        delegate?.tweetListView(self, didRefresh: true, callback: { 
            self.refreshControl.endRefreshing()
        })
    }
}
