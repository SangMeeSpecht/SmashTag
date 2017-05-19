//
//  TweetViewModel.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/15/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation
import Twitter
import UIKit
import CoreData

class TweetsViewModel {
    var tweetsSet: ((TweetsViewModel) -> ())?
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            self.tweetsSet?(self)
        }
    }
    
    var searchText: String? {
        didSet {
            removeAllTweets()
            searchForTweets()
        }
    }
    
    private var lastTwitterRequest: Twitter.Request?
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var twitterRequest: Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    func tweetCount() -> Int {
        return tweets.count
    }
    
    func tweetsCount(in section: Int) -> Int {
        return tweets[section].count
    }
    
    func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async() {
                    if request == self?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            self?.tweets.insert(newTweets, at: 0)
                            self?.updateDatabase(newTweets: newTweets)
                        }
                    }
                }
            }
        }
    }
    
    func getTweet(at index: IndexPath) -> Twitter.Tweet {
        return tweets[index.section][index.row]
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        container?.performBackgroundTask { context in
            _ = try? SearchWord.findOrCreateSearchWord(matching: self.searchText!, in: context)
            
            for twitterInfo in newTweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, searchWord: self.searchText!, in: context)
            }
            
            try? context.save()
        }
    }
    
    private func removeAllTweets() {
        tweets.removeAll()
    }
    
}

