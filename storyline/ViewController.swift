//
//  ViewController.swift
//  storyline
//
//  Created by Vadim on 25/04/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var toolbar: ToolbarView = ToolbarView(width: 0, small_height: 0, full_height: 0)
    var toolbarHeight = NSLayoutConstraint()
    var textHeight = NSLayoutConstraint()
    
    var textView = UIWebView()
    
    var minToolbarHeight: CGFloat = 0
    
    var scrollOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(rgb: backgroundColor)
        
        let pd: CGFloat = 5
        toolbar = ToolbarView(width: self.view.bounds.width, small_height: 0.14*self.view.bounds.height, full_height: view.bounds.height, title: "Хамелеон", subtitle: "Антон Павлович Чехов", subtext: "Читать 5 минут", min_margin: pd + UIApplication.shared.statusBarFrame.height)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        minToolbarHeight = toolbar.minimumTopMagin - pd
        view.addSubview(toolbar)
        let toolbarLeading = NSLayoutConstraint(item: toolbar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let toolbarTrailing = NSLayoutConstraint(item: toolbar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let toolbarTop = NSLayoutConstraint(item: toolbar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: -toolbar.layer.cornerRadius)
        toolbarHeight = NSLayoutConstraint(item: toolbar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: view.bounds.height + toolbar.layer.cornerRadius)
        NSLayoutConstraint.activate([toolbarLeading, toolbarTrailing, toolbarTop, toolbarHeight])
        
        toolbar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeToolbarState(gesture:))))
        let recUp = UISwipeGestureRecognizer(target: self, action: #selector(toolbarSwiped(gesture:)))
        recUp.direction = .up
        toolbar.addGestureRecognizer(recUp)
        let recDown = UISwipeGestureRecognizer(target: self, action: #selector(toolbarSwiped(gesture:)))
        recDown.direction = .down
        toolbar.addGestureRecognizer(recDown)
        
        textView = UIWebView()
        textView.translatesAutoresizingMaskIntoConstraints =  false
        textView.backgroundColor = .clear
        textView.scrollView.delegate = self
        if let url = Bundle.main.url(forResource: "text", withExtension: "html") {
            textView.loadRequest(URLRequest(url: url))
        }
        view.addSubview(textView)
        
        let textLeading = NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 10)
        let textTrailing = NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -10)
        let textTop = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: toolbar, attribute: .bottom, multiplier: 1, constant: 0)
        textHeight = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: -self.toolbar.small_height)
        NSLayoutConstraint.activate([textLeading, textTrailing, textTop, textHeight])
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
            self.view.layoutSubviews()
        })
    }


}

extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(toolbar.state == .fullscreen){return}
        let y: CGFloat = scrollView.contentOffset.y
        if(y <= 0){
            toolbar.alpha = 1 
            return
        }
        if(y + view.bounds.height + textHeight.constant >= scrollView.contentSize.height){
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
