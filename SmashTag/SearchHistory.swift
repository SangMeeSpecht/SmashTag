//
//  SearchHistory.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/2/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation

struct SearchHistory {
    var history = [String]()
    
    mutating func addSearchWord(toHistory word: String) {
        if wordIsUnique(inHistory: word) {
            if historyIsFull() {
                history.popLast()
            }
            history.prepend(word: word)
        }
    }
    
    private func wordIsUnique(inHistory word: String) -> Bool {
        let lowerCaseWord = word.lowercased()
        return !history.contains(lowerCaseWord)
    }
    
    private func historyIsFull() -> Bool {
        return history.count >= 3
    }
}

extension Array where Element == String {
    mutating func prepend(word: String) {
        self.insert(word, at: 0)
    }
}
