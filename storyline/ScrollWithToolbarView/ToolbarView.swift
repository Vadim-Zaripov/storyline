//
//   ToolbarView.swift
//  storyline
//
//  Created by Vadim on 26/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation
import UIKit

class ToolbarView: UIView{
    var state: ToolbarState = .fullscreen
    
    let title_fullscreen_top_cf: CGFloat = 0.15
    let title_small_top_cf: CGFloat = 0.5
    
    var image: UIImage? = nil
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var subtextLabel = UILabel()
    
    var minimumTopMagin: CGFloat = 0
    var small_height: CGFloat = 0
    var full_height: CGFloat = 0
    
    var titleLabelTop = NSLayoutConstraint()
    var titleLabelLeading = NSLayoutConstraint()
    
    var pd: CGFloat = 0
    
    init(width: CGFloat, small_height: CGFloat, full_height: CGFloat, title: String? = nil, subtitle: String? = nil, subtext: String? = nil, min_margin: CGFloat = 0, image: UIImage){
        super.init(frame: CGRect.zero)
        if(width == 0){return}
        
        self.layer.cornerRadius = 20
        minimumTopMagin = min_margin + self.layer.cornerRadius
        self.small_height = small_height + self.layer.cornerRadius
        self.full_height = full_height + self.layer.cornerRadius
        self.clipsToBounds = true
        
        let imageView: UIImageView = {
            let view = UIImageView(image: resizeImage(image: image, targetSize: CGSize(width: width, height: self.full_height)))
            view.contentMode = .bottom
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        self.addSubview(imageView)
        let imageLeading = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let imageTrailing = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let imageTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let imageBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([imageLeading, imageTrailing, imageTop, imageBottom])
        
        let quotes_btn_width = 0.1*width
        
        var title_width: CGFloat = 0
        let title_height = 0.24*self.small_height
        titleLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = .white
            label.text = title
            label.font = UIFont(name: fontName, size: FontHelper.getInterfaceFontSize(font: fontName, height: title_height))
            let d = [NSAttributedString.Key.font: label.font]
            label.adjustsFontSizeToFitWidth = true
            title_width = (title! as NSString).size(withAttributes: d as [NSAttributedString.Key : Any]).width
            pd = (width - title_width) / 2
            return label
        }()
        self.addSubview(titleLabel)
        
        if(2*pd < 3*self.layer.cornerRadius + quotes_btn_width){
            pd = 1.5*self.layer.cornerRadius + quotes_btn_width / 2
            title_width = width - 2*pd
        }
        
        titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: pd)
        let titleLabelWidth = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: title_width)
        titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: title_fullscreen_top_cf*self.full_height + self.layer.cornerRadius)
        titleLabelTop.priority = .defaultLow
        let titleLabelTopMargin = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: minimumTopMagin)
        titleLabelTopMargin.priority = .defaultHigh
        NSLayoutConstraint.activate([titleLabelLeading, titleLabelTop, titleLabelTopMargin, titleLabelWidth])
        
        let subtitle_height = 0.7*title_height
        subtitleLabel = {
            let label = UILabel()
            label.text = subtitle
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont(name: fontName, size: FontHelper.getInterfaceFontSize(font: fontName, height: subtitle_height))
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        self.addSubview(subtitleLabel)
        let subtitleLabelCenter = NSLayoutConstraint(item: subtitleLabel, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let subtitleLabelTop = NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0.25*title_height)
        NSLayoutConstraint.activate([subtitleLabelCenter, subtitleLabelTop])
        
        let subtext_height = 0.8*subtitle_height
        subtextLabel = {
            let label = UILabel()
            label.text = subtext
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont(name: fontName, size: FontHelper.getInterfaceFontSize(font: fontName, height: subtext_height))
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        self.addSubview(subtextLabel)
        let subtextLabelCenter = NSLayoutConstraint(item: subtextLabel, attribute: .centerX, relatedBy: .equal, toItem: subtitleLabel, attribute: .centerX, multiplier: 1, constant: 0)
        let subtextLabelTop = NSLayoutConstraint(item: subtextLabel, attribute: .top, relatedBy: .equal, toItem: subtitleLabel, attribute: .bottom, multiplier: 1, constant: 0.3*title_height)
        NSLayoutConstraint.activate([subtextLabelCenter, subtextLabelTop])
        
        let quotesBtn: UIImageView = {
            let view = UIImageView(image: UIImage(named: "quotes"))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = 13
            view.contentMode = .scaleAspectFit
            return view
        }()
        self.addSubview(quotesBtn)
        let quotesWidth = NSLayoutConstraint(item: quotesBtn, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: quotes_btn_width)
        let quotesHeight = NSLayoutConstraint(item: quotesBtn, attribute: .height, relatedBy: .equal, toItem: quotesBtn, attribute: .width, multiplier: 1, constant: 0)
        let quotesTrailing = NSLayoutConstraint(item: quotesBtn, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -self.layer.cornerRadius)
        let quotesTop = NSLayoutConstraint(item: quotesBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: minimumTopMagin)
        NSLayoutConstraint.activate([quotesWidth, quotesHeight, quotesTrailing, quotesTop])
        
    }
    
    func switchState(){
        if(state == .fullscreen){
            titleLabelTop.constant = title_small_top_cf*small_height
            titleLabelLeading.constant = self.layer.cornerRadius
            subtitleLabel.alpha = 0
            subtextLabel.alpha = 0
            state = .small
        }else{
            titleLabelTop.constant = title_fullscreen_top_cf*full_height
            titleLabelLeading.constant = pd
            subtitleLabel.alpha = 1
            subtextLabel.alpha = 1
            state = .fullscreen
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

enum ToolbarState{
    case fullscreen, small, medium
}
