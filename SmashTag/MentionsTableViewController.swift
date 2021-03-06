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
        navigationItem.title = Storyboard.Mention
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.Mention, for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.Image, for: indexPath) as! ImageTableViewCell
            cell.tweetURL = url
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.Search:
                if let cell = sender as? UITableViewCell {
                    if let seguedToMVC = segue.destination as? TweetTableViewController {
                        seguedToMVC.searchTextField.text = cell.textLabel?.text
                        _ = seguedToMVC.textFieldShouldReturn(seguedToMVC.searchTextField)
                    }
                }
            case Storyboard.ShowImage:
                if let cell = sender as? ImageTableViewCell {
                    if let seguedToMVC = segue.destination as? ImageViewController {
                        seguedToMVC.navigationItem.title = Storyboard.Image
                        seguedToMVC.imageURL = cell.tweetURL
                    }
                }
            default: break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.Search, let cell = sender as? UITableViewCell {
            if let url = cell.textLabel?.text, url.hasPrefix("http") {
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                return false
            }
        }
        return true
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
    
    private struct Storyboard {
        static let Search = "Search"
        static let ShowImage = "Show Image"
        static let Image = "Image"
        static let Mention = "Mention"
    }
}
