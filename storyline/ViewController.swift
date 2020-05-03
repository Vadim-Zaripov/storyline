//
//  ViewController.swift
//  storyline
//
//  Created by Vadim on 25/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var scrollview: ScrollWithToolbarView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textURL = Bundle.main.url(forResource: "text", withExtension: "html")!
        
        setMenu()
        
        loadBook(withIdentifier: "0", localURL: textURL) { (book) in
            guard let book = book else {return}
            print(book.name, book.author)
            data.current_book = book
            self.scrollview = ScrollWithToolbarView(frame: self.view.frame, image: UIImage(named: "bg")!, content_url: book.html_url, header: [book.name, book.author, "Читать \(book.timeToRead)мин"])
            self.view = self.scrollview!
            self.scrollview!.textView.scrollView.delegate = self
        }
        
        if (data.user != nil){
            loadQuotes(forUser: data.user!) { (quotes) in
                guard let quotes = quotes else {return}
                data.quotes = quotes
            }
        }
    }
}

//Scroll view delegate
extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollview!.updateToolbar()
    }
}

//Context menu methods
extension ViewController{
    func setMenu(){
        let new = UIMenuItem(title: new_quote_text, action: #selector(newQuote))
        let share = UIMenuItem(title: share_text, action: #selector(shareQuote))
        let copy = UIMenuItem(title: copy_text, action: #selector(copyQuote))
        
        UIMenuController.shared.menuItems = [new, share, copy]
    }
    
    @objc func newQuote(){
        if(Auth.auth().currentUser == nil){
            presentInFullScreen(LogInViewController(), animated: true, completion: nil)
            return
        }
        scrollview?.textView.getText(completion: { (txt) in
            guard let text = txt, let book = data.current_book, let usr = data.user else {return}
            if (data.quotes == nil)  {return}
            let quote = Quote(text: text, book_name: book.name, book_author: book.author)
            createQuote(forUser: usr, withIndex: String(data.quotes!.count), quote: quote) { (success) in
                if(success){
                    print("Successfully created new quote!")
                }
            }
        })
    }
    
    @objc func shareQuote(){
        if(Auth.auth().currentUser == nil){
            presentInFullScreen(LogInViewController(), animated: true, completion: nil)
            return
        }
        scrollview?.textView.getText(completion: { (txt) in
            guard let text = txt, let book = data.current_book else {return}
            let full_string_to_share = "\"" + text + "\"\n" + book.name + "\n" + book.author
            print("Sharing quote: \(full_string_to_share)")
            
            let activityVC = UIActivityViewController(activityItems: [full_string_to_share], applicationActivities: nil)
            self.present(activityVC, animated: true)
        })
    }
    
    @objc func copyQuote(){
        if(Auth.auth().currentUser == nil){
            presentInFullScreen(LogInViewController(), animated: true, completion: nil)
            return
        }
        scrollview?.textView.getText(completion: { (txt) in
            guard let text = txt, let book = data.current_book else {return}
            let full_string_to_copy = "\"" + text + "\"\n" + book.name + "\n" + book.author
            print("Copying quote: \(full_string_to_copy)")
            UIPasteboard.general.string = full_string_to_copy
        })
    }
}
