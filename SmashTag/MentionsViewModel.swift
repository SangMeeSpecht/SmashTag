//
//  MentionsViewModel.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/17/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation
import Twitter

class MentionsViewModel {
    private var mentions: [Mentions] = []
    
    private struct Mentions {
        var category: String
        var data: [IndividualMentions]
    }
    
    enum IndividualMentions {
        case Keyword(String)
        case Image(URL, Double)
    }
    
    func organizeMentions(for tweet: Twitter.Tweet) {
        let images = tweet.media
        let hashtags = tweet.hashtags
        let users = tweet.userMentions
        let urls = tweet.urls
    
        if images.count > 0 {
            mentions.append(Mentions(category: "Images", data: images.map { IndividualMentions.Image($0.url, $0.aspectRatio) } ))
        }

        if hashtags.count > 0 {
            mentions.append(Mentions(category: "Hashtags", data: hashtags.map { IndividualMentions.Keyword($0.keyword) } ))
        }
    
        if users.count > 0 {
            mentions.append(Mentions(category: "Users", data: users.map { IndividualMentions.Keyword($0.keyword) } ))
        }

        if urls.count > 0 {
            mentions.append(Mentions(category: "URLs", data: urls.map { IndividualMentions.Keyword($0.keyword) } ))
        }
    }
    
    func mentionCategoryCount() -> Int {
        return mentions.count
    }
    
    func mentionCount(in section: Int) -> Int {
        return mentions[section].data.count
    }
    
    func mentionCategoryTitle(in section: Int) -> String {
        return mentions[section].category
    }
    
    func getMention(in path: IndexPath) -> IndividualMentions {
        return mentions[path.section].data[path.row]
    }
}
