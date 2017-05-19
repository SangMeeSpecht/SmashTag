 //
 //  TweetTableViewController.swift
 //  SmashTag
 //
 //  Created by SangMee Specht on 4/24/17.
 //  Copyright © 2017 SangMee Specht. All rights reserved.
 //
 
 import UIKit
 
 class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    var tweetsViewModel: TweetsViewModel? {
        didSet {
            self.tweetsViewModel?.tweetsSet = { [unowned self] viewModel in
                self.tableView.reloadData()
            }
        }
    }
    
    var searchText: String? {
        didSet {
            title = searchText
            if let viewModel = tweetsViewModel {
                viewModel.searchText = searchText!
                searchHistoryViewModel?.addSearchWord(toHistory: searchText!)
            }
        }
    }
    
    private var history: SearchHistory?
    private var searchHistoryViewModel: SearchHistoryViewModel?

    
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
                        seguedToMVC.mentionsViewModel = MentionsViewModel(with: (tweetsViewModel?.getTweet(at: indexPath!))!)
                    }
                }
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModels()
        formatCellDimensions()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetsViewModel!.tweetCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsViewModel!.tweetsCount(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        if let tweetCell = cell as? TweetTableViewCell {
            let tweet = tweetsViewModel?.getTweet(at: indexPath)
            tweetCell.tweetViewModel = TweetViewModel(tweet: tweet!)
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
    
    private func setupViewModels() {
        tweetsViewModel = TweetsViewModel()
        history = SearchHistory()
        searchHistoryViewModel = SearchHistoryViewModel(history: history!)
        if let word = searchText {
            tweetsViewModel?.searchText = word
            searchHistoryViewModel?.addSearchWord(toHistory: word)
        }
    }
 }
 
