//
//  SearchHistoryViewModel.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/16/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import Foundation
import Twitter
import UIKit
import CoreData

class SearchHistoryViewModel {
    var historyModel: SearchHistory?
    let defaults = UserDefaults.standard
    var searchHistory = [String]()
    
    init(history: SearchHistory) {
        self.historyModel = history
    }
    
    func addSearchWord(toHistory word: String) {
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
    
    func historyCount() -> Int? {
        return historyModel?.getSearchHistory().count
    }
    
    func getSearchWord(at index: Int) -> String? {
        return historyModel?.getSearchHistory()[index]
    }
    
    private func wordIsUnique(inHistory history: [String], word: String) -> Bool {
        let lowerCaseWord = word.lowercased()
        
        if history.contains(word) || history.contains(lowerCaseWord) {
            return false
        }
        return true
    }
    
    private func historyIsFull(inHistory history: [String]) -> Bool {
        return history.count >= 100
    }
}
