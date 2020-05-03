//
//  User.swift
//  storyline
//
//  Created by Vadim on 29/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

struct DatabaseUser{
    let id, name: String
    var interests: [Int]
    let stats: Stats
    
    init(id: String, name: String, interests: [Int], stats: Stats){
        self.id = id
        self.name = name
        self.interests = interests
        self.stats = stats
    }
}

struct Stats{
    let level, streak: Int
    let lastDate: Date
    
    init(level: Int, streak: Int, lastDate: Date){
        self.level = level
        self.streak = streak
        self.lastDate = lastDate
    }
}
