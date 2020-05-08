//
//  Book.swift
//  storyline
//
//  Created by Vadim on 28/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

struct Book{
    let uid, name, author: String
    let timeToRead: Int
    let html_url: URL?
    let tags: [Int]
    
    init(uid: String, name: String, author: String, timeToRead: Int, url: URL?, tags: [Int]) {
        self.uid = uid
        self.name = name
        self.author = author
        self.timeToRead = timeToRead
        self.html_url = url
        self.tags = tags
    }
}
