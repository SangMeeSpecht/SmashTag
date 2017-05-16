 //
 //  TweetTableViewController.swift
 //  SmashTag
 //
 //  Created by SangMee Specht on 4/24/17.
 //  Copyright © 2017 SangMee Specht. All rights reserved.
 //
 
 import UIKit
 
 class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweetViewModel = TweetViewModel()
    private var history = SearchHistory()
    private var searchHistoryViewModel: SearchHistoryViewModel?

    var searchText: String? {
        didSet {
            tweetViewModel.searchText = searchText!
            title = searchText
            searchHistoryViewModel?.addSearchWord(toHistory: searchText!)
        }
    }
    
    func reloadTableView() {
        tableView.reloadData()
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
            case Storyboard.SegueIdentifier:
                if let cell = sender as? TweetTableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    if let seguedToMVC = segue.destination as? MentionsTableViewController {
                        seguedToMVC.tweet = tweetViewModel.getTweet(at: indexPath!)
                    }
                }
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "reloadTableData"), object: nil)
        searchHistoryViewModel = SearchHistoryViewModel(history: history)
        
        formatCellDimensions()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetViewModel.tweetCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetViewModel.tweetsCount(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweetViewModel.getTweet(at: indexPath)
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let SegueIdentifier = "Show Mentions"
    }
    
    private func formatCellDimensions() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
 }
 
