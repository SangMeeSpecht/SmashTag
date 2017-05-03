 //
 //  TweetTableViewController.swift
 //  SmashTag
 //
 //  Created by SangMee Specht on 4/24/17.
 //  Copyright © 2017 SangMee Specht. All rights reserved.
 //
 
 import UIKit
 import Twitter
 
 private var history = SearchHistory()
 
 class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
            
            history.addSearchWord(toHistory: searchText!)
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Mentions":
                if let cell = sender as? TweetTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    if let seguedToMVC = segue.destination as? MentionsTableViewController {
                        seguedToMVC.tweet = tweets[(indexPath?.section)!][(indexPath?.row)!]
                    }
                }
            default: break
            }
        }
    }
     
    private var twitterRequest: Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async() {
                    if request == self?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            self?.tweets.insert(newTweets, at: 0)
                        }
                    }
                }
            }
        }
    }
 }
 
