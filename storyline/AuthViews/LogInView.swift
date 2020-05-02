//
//  LogInView.swift
//  storyline
//
//  Created by Vadim on 01/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import Foundation
import UIKit

class LogInView: UIView{
    
    var submit_btn: UIButton!
    var google_submit_btn: UIButton!
    
    var email_field: UITextField!
    var password_field: UITextField!
    
    var forgot_btn: UIButton!
    var sign_up_btn: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let standartHeight = 0.05*frame.height
        let font_size = FontHelper.getInterfaceFontSize(font: fontName, height: standartHeight)
        
        //Title
        let title_label: UILabel = {
            let label = UILabel()
            label.bounds = CGRect(x: 0, y: 0, width: 0.8*frame.width, height: frame.height / 18)
            label.center = CGPoint(x: 0.5*frame.width, y: frame.height / 5)
            label.text = log_in_title
            label.textAlignment = .center
            let f_size = FontHelper.getFontSize(strings: [log_in_title], font: fontName, maxFontSize: 120, width: label.bounds.width, height: label.bounds.height)
            label.font = UIFont(name: fontName, size: CGFloat(f_size))
            return label
        }()
        title_label.tag = 1000
        self.addSubview(title_label)
        
        //Text Fields
        for i in 0..<2{
            let y = 0.4*frame.height + ((i == 0) ? -1.5*standartHeight : 0.5*standartHeight)
            let edit_text: UITextField = {
                let ed_text = UITextField()
                ed_text.bounds = CGRect(x: 0, y: 0, width: 0.8*frame.width, height: standartHeight)
                ed_text.center = CGPoint(x: frame.width / 2, y: y + ed_text.bounds.height / 2)
                ed_text.text = ""
                ed_text.font = UIFont(name: fontName, size: font_size)
                ed_text.backgroundColor = UIColor.clear
                ed_text.isUserInteractionEnabled = true
                ed_text.textAlignment = .left
                
                let bottomLine = CALayer()
                bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:ed_text.frame.height - 1), size: CGSize(width: ed_text.frame.width, height: 1))
                bottomLine.backgroundColor = UIColor.black.cgColor
                ed_text.borderStyle = .none
                ed_text.layer.addSublayer(bottomLine)
                
                return ed_text
            }()
            
            if(i == 0){edit_text.keyboardType = .emailAddress}
            edit_text.isSecureTextEntry = (i == 1)
            edit_text.tag = i + 1
            edit_text.attributedPlaceholder = NSAttributedString(string: auth_placeholders[i], attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 0.0, alpha: 0.5)])
            
            self.addSubview(edit_text)
            
            if(i == 0){
                email_field = edit_text
            }else{
                password_field = edit_text
            }
        }
        
        //Forgot password & sign up buttons
        var median: CGFloat = 0
        let f_sz_small = FontHelper.getInterfaceFontSize(font: fontName, height: 0.75*standartHeight)
        for i in 0..<2{
            let button: UIButton = {
                let btn = UIButton(frame: CGRect(x: self.subviews.last!.frame.minX, y: ((i == 0) ? (self.subviews.last!.frame.maxY + 0.75*standartHeight) : 0.87*frame.height), width: self.subviews.last!.frame.width, height: 0.75*standartHeight))
                btn.titleLabel?.font = UIFont(name: fontName, size: f_sz_small)
                btn.contentHorizontalAlignment = .left
                btn.titleLabel?.numberOfLines = i + 1
                btn.backgroundColor = UIColor.clear
                btn.setTitleColor(UIColor.init(white: 0, alpha: 0.8 + 0.2*CGFloat(i)), for: .normal)
                
                return btn
            }()
            button.setTitle(((i == 0) ? forgot_text : sign_up_invite_text), for: .normal)
            button.tag = 100 + i
            self.addSubview(button)
            
            median += button.center.y / 2
            
            if(i == 0){
                forgot_btn = button
            }else{
                sign_up_btn = button
            }
        }
        
        let pd = 0.05*frame.width
        
        //Submit button
        let finish_btn: UIButton = {
            let btn = UIButton()
            btn.bounds = CGRect(x: 0, y: 0, width: 0.4*frame.width, height: frame.height / 18)
            btn.setTitle("", for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor = UIColor.clear
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            btn.center = CGPoint(x: (frame.width - 2*btn.bounds.width - pd) / 2 + btn.bounds.width / 2, y: median)
            btn.layer.cornerRadius = btn.bounds.height / 2
            btn.isUserInteractionEnabled = true
            
            return btn
        }()
        finish_btn.tag = 800
        self.addSubview(finish_btn)
        submit_btn = finish_btn
        
        let submit_img: UIImageView = {
            let image = resizeImageToFit(image: UIImage(named: "arrow")!, targetSize: CGSize(width: finish_btn.bounds.width - 2*finish_btn.layer.cornerRadius, height: 0.7*finish_btn.bounds.height))
            let img = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
            img.tintColor = UIColor.black
            img.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            img.center = finish_btn.center
            return img
        }()
        submit_img.tag = 801
        self.addSubview(submit_img)
        
        //Google auth btn
        let google_btn: UIButton = {
            let btn = UIButton()
            btn.bounds = finish_btn.bounds
            btn.center = CGPoint(x: finish_btn.frame.maxX + pd + btn.bounds.width / 2, y: median)
            btn.backgroundColor = UIColor.clear
            btn.layer.cornerRadius = btn.bounds.height / 2
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.black.cgColor
            
            return btn
        }()
        google_btn.tag = 802
        self.addSubview(google_btn)
        google_submit_btn = google_btn
        
        let google_image_view: UIImageView = {
            let img = UIImage(named: "google_logo")
            let image_view = UIImageView(image: img)
            
            let h = 0.9*google_btn.bounds.height
            let newSize = CGSize(width: h*(img!.size.width / img!.size.height), height: h)
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            image_view.bounds = rect
            image_view.center = google_btn.center
            
            return image_view
        }()
        self.addSubview(google_image_view)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
