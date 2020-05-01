//
//  ScrollWithToolbarView.swift
//  storyline
//
//  Created by Vadim on 28/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ScrollWithToolbarView: UIView{
    
    var toolbar: ToolbarView = ToolbarView(width: 0, small_height: 0, full_height: 0, image: UIImage(named: "bg")!)
    var toolbarHeight = NSLayoutConstraint()
    var textHeight = NSLayoutConstraint()
    
    var textView = CustomMenuWebView()
    
    var minToolbarHeight: CGFloat = 0
    
    var scrollOffset: CGFloat = 0
    
    init(frame: CGRect, image: UIImage, content_url: URL, header: [String]){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(rgb: bgColor)
        
        let pd: CGFloat = 5
        toolbar = ToolbarView(width: self.bounds.width, small_height: 0.14*self.bounds.height, full_height: self.bounds.height, title: header[0], subtitle: header[1], subtext: header[2], min_margin: pd + UIApplication.shared.statusBarFrame.height, image: image)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        minToolbarHeight = toolbar.minimumTopMagin - pd
        self.addSubview(toolbar)
        let toolbarLeading = NSLayoutConstraint(item: toolbar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let toolbarTrailing = NSLayoutConstraint(item: toolbar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let toolbarTop = NSLayoutConstraint(item: toolbar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -toolbar.layer.cornerRadius)
        toolbarHeight = NSLayoutConstraint(item: toolbar, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: self.bounds.height + toolbar.layer.cornerRadius)
        NSLayoutConstraint.activate([toolbarLeading, toolbarTrailing, toolbarTop, toolbarHeight])
        
        toolbar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeToolbarState(gesture:))))
        let recUp = UISwipeGestureRecognizer(target: self, action: #selector(toolbarSwiped(gesture:)))
        recUp.direction = .up
        toolbar.addGestureRecognizer(recUp)
        let recDown = UISwipeGestureRecognizer(target: self, action: #selector(toolbarSwiped(gesture:)))
        recDown.direction = .down
        toolbar.addGestureRecognizer(recDown)
        
        textView = CustomMenuWebView()
        textView.translatesAutoresizingMaskIntoConstraints =  false
        textView.backgroundColor = .clear
        textView.load(URLRequest(url: content_url))
        self.addSubview(textView)
        
        let textLeading = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        let textTrailing = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10)
        let textTop = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: toolbar, attribute: .bottom, multiplier: 1, constant: 0)
        textHeight = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -self.toolbar.small_height)
        NSLayoutConstraint.activate([textLeading, textTrailing, textTop, textHeight])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func toolbarSwiped(gesture: UISwipeGestureRecognizer){
        if gesture.state == .ended {
            if((toolbar.state == .fullscreen && gesture.direction == .up) || (toolbar.state == .small && gesture.direction == .down)){
                changeToolbarState(gesture: nil)
            }
        }
    }
    
    @objc func changeToolbarState(gesture: UITapGestureRecognizer?){
        UIView.animate(withDuration: 0.5, animations: {
            self.toolbar.alpha = 1
            if(self.toolbar.state == .fullscreen){
                self.toolbarHeight.constant = self.toolbar.small_height
            }else{
                self.toolbarHeight.constant = self.toolbar.full_height
            }
            self.toolbar.switchState()
            self.toolbar.layoutSubviews()
            self.layoutSubviews()
        })
    }
    
    func updateToolbar(){
        if(toolbar.state == .fullscreen){return}
        let y: CGFloat = textView.scrollView.contentOffset.y
        if(y <= 0){
            toolbar.alpha = 1
            return
        }
        if(y + self.bounds.height + textHeight.constant >= textView.scrollView.contentSize.height){
            toolbar.alpha = 0
            return
        }
        let newHeaderViewHeight: CGFloat = toolbarHeight.constant + (scrollOffset - y)

        if newHeaderViewHeight > toolbar.small_height {
            toolbarHeight.constant = toolbar.small_height
            toolbar.alpha = 1
        } else if newHeaderViewHeight < minToolbarHeight {
            toolbarHeight.constant = minToolbarHeight
            toolbar.alpha = 0
        } else {
            toolbar.alpha = (newHeaderViewHeight - minToolbarHeight) / (toolbar.small_height - minToolbarHeight)
            toolbarHeight.constant = newHeaderViewHeight
            //scrollView.contentOffset.y = 0
        }
        textHeight.constant = -toolbarHeight.constant
        scrollOffset = y
    }
}
