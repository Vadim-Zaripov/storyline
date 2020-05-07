//
//  QuotesView.swift
//  storyline
//
//  Created by Vadim on 04/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class QuotesView: UIScrollView {

    var quotes_views: [QuoteCardView] = []
    var padding: CGFloat = 0
    
    init(frame: CGRect, quotes: [Quote]){
        super.init(frame: frame)
        
        padding = 0.05*frame.width
        let title_height = 0.07*frame.height
        
        let textSize: CGFloat = 24
        let descriptionSize: CGFloat = 18
        
        let titleView: UILabel = {
            let view = UILabel()
            view.frame = CGRect(x: padding, y: 0, width: frame.width - 2*padding, height: title_height)
            view.text = my_quotes_text
            view.font = UIFont(name: fontName, size: FontHelper.getInterfaceFontSize(font: fontName, height: title_height))
            return view
        }()
        self.addSubview(titleView)
        
        var y = titleView.frame.maxY + padding
        quotes_views = []
        for quote in quotes{
            let quoteView = QuoteCardView(frame: CGRect(x: padding, y: y, width: frame.width - 2*padding, height: 0), quote: quote, quoteSize: textSize, descriptionSize: descriptionSize)
            y += padding + quoteView.frame.height
            self.addSubview(quoteView)
            quotes_views.append(quoteView)
        }
        
        self.contentSize = CGSize(width: frame.width, height: y)
    }
    
    func removeQuote(quote_view: QuoteCardView){
        var to_move_up: CGFloat = 0
        for quote_v in quotes_views{
            if(quote_v === quote_view){
                to_move_up = quote_v.bounds.height + padding
                quote_v.removeFromSuperview()
            }else{
                quote_v.center = CGPoint(x: quote_v.center.x, y: quote_v.center.y - to_move_up)
            }
        }
        quotes_views.remove(at: quotes_views.firstIndex(of: quote_view)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
