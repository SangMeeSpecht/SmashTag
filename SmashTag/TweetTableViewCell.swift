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
            setCreatedLabel(forTweet: tweet)
        }
    }
    
    private func setTextLabel(forTweet tweet: Twitter.Tweet) {
        tweetTextLabel?.text = tweet.text
        if tweetTextLabel?.text != nil {
            for _ in tweet.media {
                tweetTextLabel.text! += "  📷"
            }
        }
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
    
    private func setCreatedLabel(forTweet tweet: Twitter.Tweet) {
        let formatter = DateFormatter()
        
        if NSDate().timeIntervalSince(tweet.created) > oneDayOld {
            formatter.dateStyle = .short
        } else {
            formatter.timeStyle = .short
        }
        
        tweetCreatedLabel?.text = formatter.string(from: tweet.created)
    }
}
