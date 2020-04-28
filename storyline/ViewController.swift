//
//  ViewController.swift
//  storyline
//
//  Created by Vadim on 25/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scrollview: ScrollWithToolbarView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textURL = Bundle.main.url(forResource: "text", withExtension: "html")!
        
        loadBook(withIdentifier: "0", localURL: textURL) { (book) in
            if let book = book{
                print(book.name, book.author)
                self.scrollview = ScrollWithToolbarView(frame: self.view.frame, image: UIImage(named: "bg")!, content_url: book.html_url, header: [book.name, book.author, "Читать \(book.timeToRead)мин"])
                self.view = self.scrollview!
                self.scrollview!.textView.scrollView.delegate = self
            }
        }
    }


}

extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollview!.updateToolbar()
    }
}
