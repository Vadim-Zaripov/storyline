//
//  Quotes.swift
//  storyline
//
//  Created by Vadim on 29/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

struct Quote{
    let text: String
    let book_name: String
    let book_author: String
    
    init(text: String, book_name: String, book_author: String){
        self.text = text
        self.book_name = book_name
        self.book_author = book_author
    }
}
