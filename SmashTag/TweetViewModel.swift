//
//  TweetViewModel.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/18/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation
import Twitter
import UIKit

class TweetViewModel {
    var tweet: Twitter.Tweet?
    
    private let mentionColors = [
        "hashtags": UIColor.magenta,
        "urls": UIColor.purple,
        "userMentions": UIColor.green
    ]
    
    private let oneDayOld: Double = 24 * 60 * 60
    
    init(tweet: Twitter.Tweet) {
        self.tweet = tweet
    }
    
    
    func getColoredMentions() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: (tweet?.text)!)
        
        attributedString.setMentionsColor(mentions: (tweet?.hashtags)!, color: mentionColors["hashtags"]!)
        attributedString.setMentionsColor(mentions: (tweet?.urls)!, color: mentionColors["urls"]!)
        attributedString.setMentionsColor(mentions: (tweet?.userMentions)!, color: mentionColors["userMentions"]!)
        
        return attributedString
    }

    func addCameraIcon() -> String {
        var camera = ""
        
        for _ in (tweet?.media)! {
            camera += "  📷"
        }
        
        return camera
    }
    
    func getScreenName() -> String {
        return "\(tweet!.user)"
    }
    
    func getTimeCreated() -> String {
        let formatter = DateFormatter()
        
        if NSDate().timeIntervalSince((tweet?.created)!) > oneDayOld {
            formatter.dateStyle = .short
        } else {
            formatter.timeStyle = .short
        }
        
        return formatter.string(from: tweet!.created)
    }
    
    func getProfileImage() -> UIImage {
        let profileImageURL = tweet?.user.profileImageURL
        let imageData = try? Data(contentsOf: profileImageURL!)
        return UIImage(data: imageData!)!
    }
}

private extension NSMutableAttributedString {
    func setMentionsColor(mentions: [Mention], color: UIColor) {
        for mention in mentions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
