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
    
    func getSearchHistory() -> [String] {
        return defaults.object(forKey: "history") as? [String] ?? [String]()
    }
}

extension Array where Element == String {
    mutating func prepend(word: String) {
        self.insert(word, at: 0)
    }
}
