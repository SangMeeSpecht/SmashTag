//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by SangMee Specht on 4/24/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private let oneDayOld: Double = 24 * 60 * 60
    
    private let mentionColors = [
        "hashtags": UIColor.magenta,
        "urls": UIColor.purple,
        "userMentions": UIColor.green
    ]
    
    private func updateUI() {
        removeExistingTweetInfo()
        populateWithNewTweetInfo()
    }
    
    private func removeExistingTweetInfo() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
    }
    
    private func populateWithNewTweetInfo() {
        if let tweet = self.tweet {
            setTextLabel(forTweet: tweet)
            setScreenNameLabel(forTweet: tweet)
            setProfileImage(forTweet: tweet)
            tweetCreatedLabel?.text = timeCreated(forTweet: tweet)
        }
    }
    
    private func setTextLabel(forTweet tweet: Twitter.Tweet) {
        tweetTextLabel?.attributedText = coloredMentions(inTweet: tweet)
        addCameraIconForImages(inTweet: tweet)
    }
    
    private func setScreenNameLabel(forTweet tweet: Twitter.Tweet) {
        tweetScreenNameLabel?.text = "\(tweet.user)"
    }
    
    private func setProfileImage(forTweet tweet: Twitter.Tweet) {
        if let profileImageURL = tweet.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        }
    }
    
    private func timeCreated(forTweet tweet: Twitter.Tweet) -> String {
        let formatter = DateFormatter()
        
        if NSDate().timeIntervalSince(tweet.created) > oneDayOld {
            formatter.dateStyle = .short
        } else {
            formatter.timeStyle = .short
        }
        
        return formatter.string(from: tweet.created)
    }
    
    private func coloredMentions(inTweet tweet: Twitter.Tweet) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: tweet.text)
        
        attributedString.setMentionsColor(mentions: tweet.hashtags, color: mentionColors["hashtags"]!)
        attributedString.setMentionsColor(mentions: tweet.urls, color: mentionColors["urls"]!)
        attributedString.setMentionsColor(mentions: tweet.userMentions, color: mentionColors["userMentions"]!)
        
        return attributedString
    }
    
    private func addCameraIconForImages(inTweet tweet: Twitter.Tweet) {
        for _ in tweet.media {
            tweetTextLabel.text! += "  📷"
        }
    }
}


private extension NSMutableAttributedString {
    func setMentionsColor(mentions: [Mention], color: UIColor) {
        for mention in mentions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
