//
//  QuoteCardView.swift
//  storyline
//
//  Created by Vadim on 07/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class QuoteCardView: UITextView {

    var quote: Quote!
    
    init(frame: CGRect, quote: Quote, quoteSize: CGFloat, descriptionSize: CGFloat){
        super.init(frame: frame, textContainer: nil)
        
        self.quote = quote
        
        let text = "\"" + quote.text + "\"\n" + quote.book_name + "\n" + quote.book_author
        
        let myAttributedString = NSMutableAttributedString(string: text)
        myAttributedString.addAttribute(
            .font, value: UIFont(name: fontName, size: quoteSize)!,
            range: NSRange(location:0,length:quote.text.count + 2))

        myAttributedString.addAttributes([.font: UIFont(name: fontName, size: descriptionSize)!],
                                         range: NSRange(location: quote.text.count + 2,length: text.count - quote.text.count - 2))

        self.attributedText = myAttributedString
        
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.isScrollEnabled = false
        
        self.layer.cornerRadius = 0.05*self.frame.width
        
        self.isEditable = false
        self.isSelectable = false
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
