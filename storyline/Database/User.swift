//
//  User.swift
//  storyline
//
//  Created by Vadim on 29/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

struct DatabaseUser{
    let id: String
    var name: String
    var interests: [Int]
    var stats: Stats
    let currentStory: CurrentStory
    var history: [String]
    
    init(id: String, name: String, interests: [Int], stats: Stats, currentStory: CurrentStory, history: [String]){
        self.id = id
        self.name = name
        self.interests = interests
        self.stats = stats
        self.currentStory = currentStory
        self.history = history
    }
    
    func bookFits(bookId: String, bookTags: [Int]) -> Bool{
        return ((!history.contains(bookId)) && (interests.filter(bookTags.contains).count > 0))
    }
}

struct Stats{
    var level, streak: Int
    var lastDate: Date
    
    init(level: Int, streak: Int, lastDate: Date){
        self.level = level
        self.streak = streak
        self.lastDate = lastDate
    }
}

struct CurrentStory{
    let creationDate: Date
    let uid: String
    init(creationDate: Date, uid: String){
        self.creationDate = creationDate
        self.uid = uid
    }
}
