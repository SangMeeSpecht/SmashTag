//
//  PopularMentionsTableViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/8/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionsTableViewController: FetchedResultsTableViewController {
    var searchWord: String? { didSet { updateUI() } }
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    var fetchedResultsController: NSFetchedResultsController<SearchWordMention>?
    
    private func updateUI() {
        if let context = container?.viewContext, searchWord != nil {
            let request: NSFetchRequest<SearchWordMention> = SearchWordMention.fetchRequest()
            request.predicate = NSPredicate(format: "searchWord.word = %@ AND count > 1", searchWord!)
            request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false), NSSortDescriptor(key: "mention.text", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))]
            
            fetchedResultsController = NSFetchedResultsController<SearchWordMention>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pop Mention", for: indexPath)
        
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.mention?.text
            cell.detailTextLabel?.text = "\(String(mention.count)) mentions"
        }

        return cell
    }
}
