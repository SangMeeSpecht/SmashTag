//
//  MentionsViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 4/25/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    let mentionCategories = ["Images", "Hashtags", "Users", "URLs"]
    
    private var mentions: [Mentions] = []
    
    private struct Mentions {
        var category: String
        var data: [IndividualMentions]
    }
    
    private enum IndividualMentions {
        case Keyword(String)
        case Image(URL, Double)
    }
    
    var tweet: Twitter.Tweet? {
        didSet {
            if let images = tweet?.media {
                if images.count > 0 {
                    mentions.append(Mentions(category: "Images", data: images.map { IndividualMentions.Image($0.url, $0.aspectRatio) } ))
                }
            }
            
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(category: "Hashtags", data: hashtags.map { IndividualMentions.Keyword($0.keyword) } ))
                }
            }
            
            if let users = tweet?.userMentions {
                if users.count > 0 {
                    mentions.append(Mentions(category: "Users", data: users.map { IndividualMentions.Keyword($0.keyword) } ))
                }
            }
            
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(category: "URLs", data: urls.map { IndividualMentions.Keyword($0.keyword) } ))
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mentions"
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].category
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMention = mentions[indexPath.section].data[indexPath.row]
        
        switch currentMention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mention", for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mention", for: indexPath)
            cell.imageView?.image = fetchImage(forTweet: url)
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Search":
                if let cell = sender as? UITableViewCell {
                    if let seguedToMVC = segue.destination as? TweetTableViewController {
                        seguedToMVC.searchTextField.text = cell.textLabel?.text
                        seguedToMVC.textFieldShouldReturn(seguedToMVC.searchTextField)
                    }
                }
            default: break
            }
        }
    }
    

    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.width / CGFloat((tweet?.media[indexPath.row].aspectRatio)!)
//    }
    
//    fix to not run on main thread!!!
    private func fetchImage(forTweet imageURL: URL) -> UIImage? {
        let url = imageURL
            if let imageData = try? Data(contentsOf: url) {
                return UIImage(data: imageData)
            }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Image(_, let ratio):
            return self.view.frame.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
