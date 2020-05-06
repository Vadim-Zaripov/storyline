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
    var user: DatabaseUser? = nil
    var firebase_user: User? = nil
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
                    book = Book(uid: id, name: data["name"] as! String, author: data["author"] as! String, timeToRead: data["time_to_read"] as! Int, url: localURL, tags: data["tags"] as! [Int])
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

func loadBook(forUser user: DatabaseUser, localURL: URL, completion: ((Book?) -> Void)?){
    if(Calendar.current.dateComponents([.day], from: user.currentStory.creationDate, to: Calendar.current.startOfDay(for: Date())).day! == 0){
        loadBook(withIdentifier: user.currentStory.uid, localURL: localURL, completion: completion)
        return
    }
    let booksCollection = database.collection("books")
    let storage = Storage.storage()
    
    booksCollection.getDocuments { (querySnapshot, err) in
        if let error = err{
            print("Error loading books: \(error.localizedDescription)")
        }else{
            var flag = true
            for bookDoc in querySnapshot!.documents{
                let data = bookDoc.data()
                if(user.bookFits(bookId: bookDoc.documentID, bookTags: data["tags"] as! [Int])){
                    flag = false
                    let storageRef = storage.reference(withPath: data["path_to_text"] as! String)
                    storageRef.write(toFile: localURL) {url, error in
                        if let error = error{
                            print("Failed to load text html: \(error)")
                            return
                        }else{
                            let book = Book(uid: bookDoc.documentID, name: data["name"] as! String, author: data["author"] as! String, timeToRead: data["time_to_read"] as! Int, url: localURL, tags: data["tags"] as! [Int])
                            database.collection("users").document(user.id).updateData([
                                "history": user.history + [bookDoc.documentID],
                                "currentStory": [
                                    "creationTime": Calendar.current.startOfDay(for: Date()).toDatabaseFormat(),
                                    "storyUid": bookDoc.documentID
                                ]
                            ])
                            if let comp = completion{
                                comp(book)
                            }
                            return
                        }
                    }
                }
            }
            if let comp = completion, flag{
                comp(nil)
            }
        }
    }
    
}

func loadQuotes(forUser usr: DatabaseUser, completion: (([Quote]?) -> Void)?){
    
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

func loadUser(withId id: String, completion: ((DatabaseUser?) -> Void)?){
    let docRef = database.collection("users").document(id)
    
    var user: DatabaseUser? = nil
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists{
            let data = document.data()!
            
            let stats_data = data["stats"] as! [String: Any]
            let stats = Stats(level: stats_data["level"] as! Int, streak: stats_data["streak"] as! Int, lastDate: Date(milliseconds: stats_data["last_date"] as! Int64))
            
            let currentData = data["currentStory"] as! [String: Any]
            let currentStory = CurrentStory(creationDate: Date(milliseconds: currentData["creationTime"] as! Int64), uid: currentData["storyUid"] as! String)
            
            user = DatabaseUser(id: id, name: data["nickname"] as! String, interests: data["interests"] as! [Int], stats: stats, currentStory: currentStory, history: data["history"] as! [String])
        }else{
            print("Error loading user")
            if let error = error { print(error) }
        }
        
        if let comp = completion{
            comp(user)
        }
    }
    
}

func createQuote(forUser usr: DatabaseUser, withIndex id: String, quote: Quote, completion: @escaping ((Bool) -> Void)){
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

func uploadInterests(forUser usr: DatabaseUser, toId id: String, completion: ((Bool) -> Void)?){
    let userRef = database.collection("users").document(id)
    
    userRef.updateData([
        "interests": usr.interests,
        "nickname": usr.name
    ]) { error in
        var success = true
        if let error = error{
            print("Error while uploading interests: \(error.localizedDescription)")
            success = false
        }
        if let comp = completion{
            comp(success)
        }
    }
}

func setupUser(withId id: String, completion: ((Bool) -> Void)?){
    let userRef = database.collection("users").document(id)
    
    userRef.setData([
        "nickname": "",
        "interests": [],
        "history": [],
        "stats": [
            "level": 100,
            "streak": 0,
            "last_date": Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!).toDatabaseFormat()
        ],
        "currentStory": [
            "creationTime": Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -1, to: Date())!).toDatabaseFormat(),
            "storyUid": ""
        ],
        "history": []
    ]) { (error) in
        var success = true
        if let error = error{
            print("Error creating user: \(error)")
            success = false
        }
        if let comp = completion{
            comp(success)
        }
    }
}
