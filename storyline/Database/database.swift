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

struct Data{
    var current_book: Book? = nil
    var quotes: [Quote]? = nil
    var user: User? = nil
}

var data = Data()

func loadBook(withIdentifier id: String, localURL: URL, completion: ((Book?) -> Void)?){
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

func loadQuotes(forUser usr: User, completion: (([Quote]?) -> Void)?){
    
    var quotes: [Quote]? = nil
    
    let collection = database.collection("users").document(usr.id).collection("quotes")
    
    collection.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            quotes = []
            for document in querySnapshot!.documents {
                let data = document.data()
                quotes!.append(Quote(text: data["text"] as! String, book_name: data["book_name"] as! String, book_author: data["book_author"] as! String))
            }
        }
        if let comp = completion{
            comp(quotes)
        }
    }
}

func loadUser(withId id: String, completion: ((User?) -> Void)?){
    let docRef = database.collection("users").document(id)
    
    var user: User? = nil
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists{
            let data = document.data()!
            let stats_data = data["stats"] as! [String: Int64]
            let stats = Stats(level: Int(truncatingIfNeeded: stats_data["level"]!), streak: Int(truncatingIfNeeded: stats_data["streak"]!), lastDate: Date(milliseconds: stats_data["last_date"]!))
            user = User(id: id, name: data["nickname"] as! String, interests: data["interests"] as! [Int], stats: stats)
        }else{
            print("Error loading user")
            if let error = error { print(error) }
        }
        
        if let comp = completion{
            comp(user)
        }
    }
    
}

func createQuote(forUser usr: User, withIndex id: String, quote: Quote, completion: @escaping ((Bool) -> Void)){
    let collection = database.collection("users").document(usr.id).collection("quotes")
    
    collection.document(id).setData([
        "text": quote.text,
        "book_name": quote.book_name,
        "book_author": quote.book_author
    ]) { err in
        if let err = err{
            print("Error writing document: \(err)")
            completion(false)
        }else{
            completion(true)
        }
    }
}
