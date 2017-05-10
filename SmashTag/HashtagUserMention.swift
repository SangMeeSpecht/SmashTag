//
//  Hashtag.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/5/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class HashtagUserMention: NSManagedObject {
    
    class func findOrCreateMentions(withMention keyword: String, withSearchWord searchWord: String, in context: NSManagedObjectContext) throws -> HashtagUserMention {
        let request: NSFetchRequest<HashtagUserMention> = HashtagUserMention.fetchRequest()
        request.predicate = NSPredicate(format: "text = %@", keyword)

        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = HashtagUserMention(context: context)
        mention.text = keyword
//        let word = try? SearchWordMention.findOrCreateSearchWordMention(matchingSearchWord: searchWord, matchingMention: keyword, in: context)
//        mention.addToSearchWords(word!)
        
        return mention
    }
}
