//
//  Book.swift
//  storyline
//
//  Created by Vadim on 28/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

struct Book{
    let name, author: String
    let timeToRead: Int
    let html_url: URL
    init(name: String, author: String, timeToRead: Int, url: URL) {
        self.name = name
        self.author = author
        self.timeToRead = timeToRead
        self.html_url = url
    }
}
