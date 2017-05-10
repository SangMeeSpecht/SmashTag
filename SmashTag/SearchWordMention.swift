//
//  SearchWordMention.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/10/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import CoreData

class SearchWordMention: NSManagedObject {
    class func findOrCreateSearchWordMention(matchingSearchWord searchWord: String, matchingMention mentionWord: String, in context: NSManagedObjectContext) throws -> SearchWordMention {
        let mention = try? HashtagUserMention.findOrCreateMentions(withMention: mentionWord, withSearchWord: searchWord, in: context)
        let searchterm = try? SearchWord.findOrCreateSearchWord(matching: searchWord, in: context)
        
        let request: NSFetchRequest<SearchWordMention> = SearchWordMention.fetchRequest()
        request.predicate = NSPredicate(format: "mention = %@ AND searchWord = %@", mention!, searchterm!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let searchWordMention = SearchWordMention(context: context)
        searchWordMention.count = 1
        searchWordMention.mention = mention
        searchWordMention.searchWord = searchterm
        
        return searchWordMention
    }
    
    class func searchWordDoesNotExist(matching word: String, in context: NSManagedObjectContext) throws -> Bool {
        let searchWord = try? SearchWord.findOrCreateSearchWord(matching: word, in: context)
        let request: NSFetchRequest<SearchWordMention> = SearchWordMention.fetchRequest()
        request.predicate = NSPredicate(format: "searchWord = %@", searchWord!)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return false
            }
        } catch {
            throw error
        }
        
        return true
    }
}
