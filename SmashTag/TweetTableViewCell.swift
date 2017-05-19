//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by SangMee Specht on 4/24/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweetViewModel: TweetViewModel? {
        didSet {
            updateUI()
        }
    }
    
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
        setTextLabel()
        setScreenNameLabel()
        setProfileImage()
        tweetCreatedLabel?.text = timeCreated()
    }
    
    private func setTextLabel() {
        tweetTextLabel?.attributedText = tweetViewModel?.getColoredMentions()
        addCameraIconForImages()
    }
    
    private func setScreenNameLabel() {
        tweetScreenNameLabel?.text = tweetViewModel?.getScreenName()
    }
    
    private func setProfileImage() {
        tweetProfileImageView?.image = tweetViewModel?.getProfileImage()
    }
    
    private func timeCreated() -> String {
        return (tweetViewModel?.getTimeCreated())!
    }
    
    private func addCameraIconForImages() {
        tweetTextLabel.text! += (tweetViewModel?.addCameraIcon())!
    }
}

