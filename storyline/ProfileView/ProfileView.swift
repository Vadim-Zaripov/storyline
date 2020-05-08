//
//  ProfileView.swift
//  storyline
//
//  Created by Vadim on 04/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    var logout_btn: UIButton!
    var back_btn: UIButton!
    var quotes_view: QuotesView!
    
    init(frame: CGRect, quotes: [Quote], user: DatabaseUser){
        super.init(frame: frame)
        
        let toolbar_height = 0.14*frame.height
        
        let toolbar: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: frame.width, height: toolbar_height)
            view.backgroundColor = .clear
            
            let imageView = UIImageView(image: UIImage(named: "profile_bg"))
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: -imageView.layer.cornerRadius, width: frame.width, height: imageView.layer.cornerRadius + view.bounds.height)
            imageView.contentMode = .scaleToFill
            view.addSubview(imageView)
            
            let title_height = 0.24*view.bounds.height
            
            back_btn = UIButton(frame: CGRect(x: imageView.layer.cornerRadius, y: UIApplication.shared.statusBarFrame.height + 5, width: 0.9*title_height, height: title_height))
            back_btn.setBackgroundImage(UIImage(named: "back"), for: .normal)
            view.addSubview(back_btn)
            
            let title = UILabel(frame: CGRect(x: back_btn.frame.maxX, y: UIApplication.shared.statusBarFrame.height + 5, width: frame.width - 2*imageView.layer.cornerRadius - back_btn.frame.width - back_btn.frame.maxX, height: title_height))
            title.text = user.name
            title.font = UIFont(name: fontName, size: FontHelper.getFontSize(strings: [title.text!], font: fontName, maxFontSize: 120, width: title.bounds.width, height: title.bounds.height))
            view.addSubview(title)
            
            let description = UILabel(frame: CGRect(x: title.frame.minX, y: title.frame.maxY, width: view.bounds.width - title.frame.minX - imageView.layer.cornerRadius, height: 0.8*title.frame.height))
            description.text = streak_text[0] + String(user.stats.streak) + streak_text[1]
            description.font = UIFont(name: fontName, size: FontHelper.getFontSize(strings: [description.text!], font: fontName, maxFontSize: 120, width: description.frame.width, height: description.frame.height))
            view.addSubview(description)
            
            logout_btn = UIButton(frame: CGRect(x: frame.width - imageView.layer.cornerRadius - title_height, y: title.frame.minY, width: title_height, height: title_height))
            logout_btn.setBackgroundImage(UIImage(named: "logout"), for: .normal)
            view.addSubview(logout_btn)
            
            return view
        }()
        self.addSubview(toolbar)
        
        quotes_view = QuotesView(frame: CGRect(x: 0, y: toolbar.frame.maxY + 0.03*frame.height, width: frame.width, height: frame.height - toolbar.frame.maxY), quotes: quotes)
        self.addSubview(quotes_view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
