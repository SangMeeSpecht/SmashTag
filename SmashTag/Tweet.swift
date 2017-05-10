//
//  Tweet.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/5/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching tweetInfo: Twitter.Tweet, searchWord: String, in context: NSManagedObjectContext) throws -> Tweet {
        
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", tweetInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.id = tweetInfo.identifier
        
        for mention in (tweetInfo.hashtags + tweetInfo.userMentions) {
            if let mentions = try? HashtagUserMention.findOrCreateMentions(withMention: mention.keyword, withSearchWord: searchWord, in: context) {
                tweet.addToMentions(mentions)
            }
        }
        
        tweet.searchWord = try? SearchWord.findOrCreateSearchWord(matching: searchWord, in: context)
        
        return tweet
    }
    
    private func mentions(from tweet: Twitter.Tweet) -> [String] {
        var mentions = Array<String>()
        mentions += addHashtagMentions(from: tweet)
        mentions += addUserMentions(from: tweet)
        return mentions
    }
    
    private func addHashtagMentions(from tweet: Twitter.Tweet) -> [String] {
        var hashtags = Array<String>()
        for hashtag in tweet.hashtags {
            hashtags.append(hashtag.keyword)
        }
        return hashtags
    }
    
    private func addUserMentions(from tweet: Twitter.Tweet) -> [String] {
        var users = Array<String>()
        for user in tweet.userMentions {
            users.append(user.keyword)
        }
        return users
    }

}
