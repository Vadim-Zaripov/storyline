//
//  database.swift
//  storyline
//
//  Created by Vadim on 28/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation
import Firebase

var database: Firestore!

func loadBook(withIdentifier id: String, completion: ((Book?) -> Void)?){
    database = Firestore.firestore()
    let docRef = database.collection("books").document(id)
    
    var book: Book? = nil
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let data = document.data()!
            book = Book(name: data["name"] as! String, author: data["author"] as! String, timeToRead: data["time_to_read"] as! Int)
        } else {
            print("Document does not exist")
        }
        if let comp = completion{
            comp(book)
        }
    }
}
/*
func loadQuotes(withIdentifiers ids: [String], completion: (([Quote]?) -> Void)?){
    if(ids.count == 0){ if let comp = completion{ comp([]) } }
    
    let d = DispatchGroup()
    d.enter()
    for id in ids {
        database.collection("quotes").document(id).getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let text = data["text"] as! String
                
                
            }
            d.leave()

        }

    }

    d.notify(queue: .global(), execute: {

        // hand off to another array if this table is ever refreshed on the fly

        DispatchQueue.main.async {
            // reload table
        }

    })
}


*/
