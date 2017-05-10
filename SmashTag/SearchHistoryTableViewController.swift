//
//  SearchHistoryTableViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/2/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

private var history = SearchHistory()

class SearchHistoryTableViewController: UITableViewController {
    var searchHistory = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistory = history.getSearchHistory()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.SearchCell, for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row]
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
                        //seguedToMVC.searchTextField.text = cell.textLabel?.text
                        //_ = seguedToMVC.textFieldShouldReturn(seguedToMVC.searchTextField)
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

