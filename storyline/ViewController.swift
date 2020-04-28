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
        
        loadBook(withIdentifier: "0") { (book) in
            if let book = book{
                print(book.name, book.author)
            }
        }
        
        scrollview = ScrollWithToolbarView(frame: view.frame, image: UIImage(named: "bg")!, content_name: "text", header: ["Хамелеон", "А.П. Чехов", "Читать 5мин"])
        
        self.view = scrollview!
        
        scrollview!.textView.scrollView.delegate = self
    }


}

extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollview!.updateToolbar()
    }
}
