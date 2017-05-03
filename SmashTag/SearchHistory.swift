//
//  SearchHistory.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/2/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation

struct SearchHistory {
    static let sharedHistory = SearchHistory()
    let defaults = UserDefaults.standard
    
    mutating func addSearchWord(toHistory word: String) {
        var history = [String]()
        
        history.append(contentsOf: defaults.object(forKey: "history") as? [String] ?? [String]())
        
        if wordIsUnique(inHistory: history, word: word) {
            if historyIsFull(inHistory: history) {
                history.removeLast()
            }
            history.prepend(word: word)
        }
        
        defaults.setValue(history, forKey: "history")
    }
    
    func getSearchHistory() -> [String] {
        return defaults.object(forKey: "history") as? [String] ?? [String]()
    }
    
    private func wordIsUnique(inHistory history: [String], word: String) -> Bool {
        let lowerCaseWord = word.lowercased()
        return !history.contains(lowerCaseWord)
    }
    
    private func historyIsFull(inHistory history: [String]) -> Bool {
        return history.count >= 100
    }
}

extension Array where Element == String {
    mutating func prepend(word: String) {
        self.insert(word, at: 0)
    }
}
