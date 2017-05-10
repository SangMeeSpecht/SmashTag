//
//  SearchWord.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/5/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit
import CoreData

class SearchWord: NSManagedObject {

    class func findOrCreateSearchWord(matching word: String, in context: NSManagedObjectContext) throws -> SearchWord {
        
        let request: NSFetchRequest<SearchWord> = SearchWord.fetchRequest()
        request.predicate = NSPredicate(format: "word like[c] %@", word)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let searchWord = SearchWord(context: context)
        searchWord.word = word
        return searchWord
    }
}
