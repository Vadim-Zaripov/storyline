//
//  database.swift
//  storyline
//
//  Created by Vadim on 28/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

var database: Firestore!

func loadBook(withIdentifier id: String, localURL: URL, completion: ((Book?) -> Void)?){
    database = Firestore.firestore()
    let docRef = database.collection("books").document(id)
    
    let storage = Storage.storage()

    var book: Book? = nil
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let data = document.data()!
            let storageRef = storage.reference(withPath: data["path_to_text"] as! String)
            print("Loading image from path: \(data["path_to_text"] as! String)")
            
            storageRef.write(toFile: localURL) {url, error in
                if let error = error{
                    print("Failed to load text html: \(error)")
                }else{
                    book = Book(name: data["name"] as! String, author: data["author"] as! String, timeToRead: data["time_to_read"] as! Int, url: localURL)
                }
                if let comp = completion{
                    comp(book)
                }
            }
        } else {
            print("Document does not exist")
            if let comp = completion{
                comp(book)
            }
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
