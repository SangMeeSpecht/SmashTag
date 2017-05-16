//
//  SearchHistoryTableViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/2/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    private var history = SearchHistory()
    var searchHistoryViewModel: SearchHistoryViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistoryViewModel = SearchHistoryViewModel(history: history)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistoryViewModel?.historyCount() ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.SearchCell, for: indexPath)
        cell.textLabel?.text = searchHistoryViewModel?.getSearchWord(at: indexPath.row)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SearchCell:
                if let cell = sender as? UITableViewCell {
                    if let seguedToMVC = segue.destination as? TweetTableViewController {
                        seguedToMVC.searchTextField.text = cell.textLabel?.text
                        _ = seguedToMVC.textFieldShouldReturn(seguedToMVC.searchTextField)
                    }
                }
            case Storyboard.PopularMentions:
                if let cell = sender as? UITableViewCell {
                    if let seguedToMVC = segue.destination as? PopularMentionsTableViewController {
                        seguedToMVC.searchWord = cell.textLabel?.text
                    }
                }
            default: break
            }
        }
    }
    
    private struct Storyboard {
        static let SearchCell = "Search Word"
        static let PopularMentions = "Popular Mentions"
    }
}

