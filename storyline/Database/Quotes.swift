//
//  Quotes.swift
//  storyline
//
//  Created by Vadim on 29/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation

class Quote{
    let text: String
    let book: Book
    
    init(text: String, book: Book){
        self.text = text
        self.book = book
    }
}
