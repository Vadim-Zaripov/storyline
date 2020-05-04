//
//  QuotesView.swift
//  storyline
//
//  Created by Vadim on 04/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class QuotesView: UIScrollView {

    init(frame: CGRect, quotes: [Quote]){
        super.init(frame: frame)
        
        let padding = 0.05*frame.width
        let title_height = 0.07*frame.height
        
        let textSize: CGFloat = 24
        let description_size: CGFloat = 18
        
        let titleView: UILabel = {
            let view = UILabel()
            view.frame = CGRect(x: padding, y: 0, width: frame.width - 2*padding, height: title_height)
            view.text = my_quotes_text
            view.font = UIFont(name: fontName, size: FontHelper.getInterfaceFontSize(font: fontName, height: title_height))
            return view
        }()
        self.addSubview(titleView)
        
        var y = titleView.frame.maxY + padding
        for quote in quotes{
            let textView = UITextView()
            let text = "\"" + quote.text + "\"\n" + quote.book_name + "\n" + quote.book_author
            
            let myAttributedString = NSMutableAttributedString(string: text)
            myAttributedString.addAttribute(
                .font, value: UIFont(name: fontName, size: textSize)!,
                range: NSRange(location:0,length:quote.text.count + 2))

            myAttributedString.addAttributes([.font: UIFont(name: fontName, size: description_size)!],
                                             range: NSRange(location: quote.text.count + 2,length: text.count - quote.text.count - 2))

            textView.attributedText = myAttributedString
            
            textView.frame = CGRect(x: padding, y: y, width: frame.width - 2*padding, height: 0)
            
            let fixedWidth = textView.frame.size.width
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            textView.isScrollEnabled = false
            
            textView.layer.cornerRadius = padding / 2
            
            textView.isEditable = false
            textView.isSelectable = false
            
            textView.layer.masksToBounds = false
            textView.layer.shadowColor = UIColor.black.cgColor
            textView.layer.shadowOpacity = 0.4
            textView.layer.shadowRadius = 3
            textView.layer.shadowOffset = CGSize(width: 3, height: 3)
            
            y += padding + textView.frame.height
            self.addSubview(textView)
        }
        
        self.contentSize = CGSize(width: frame.width, height: y)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
