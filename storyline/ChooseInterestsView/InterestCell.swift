//
//  InterestCell.swift
//  storyline
//
//  Created by Vadim on 02/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
    
    var enabled = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 0.1*frame.height
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 3
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        let text_height = 0.15*frame.height
        let pd = 0.1*frame.width
        
        let image_view: UIImageView = {
            let sz = CGSize(width: frame.width - 2*pd, height: frame.height - 3*pd - text_height)
            let image = resizeImageToFit(image: UIImage(named: "books")!, targetSize: sz)
            let img_v = UIImageView(image: image)
            img_v.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
            img_v.center = CGPoint(x: frame.width / 2, y: pd + img_v.frame.height / 2)
            
            return img_v
        }()
        contentView.addSubview(image_view)
        
        
        let text_view: UILabel = {
            let view = UILabel()
            view.frame = CGRect(x: layer.cornerRadius, y: image_view.frame.maxY + pd, width: frame.width - 2*layer.cornerRadius, height: text_height)
            view.text = "Категория"
            view.textAlignment = .center
            view.font = UIFont(name: fontName, size: FontHelper.getFontSize(strings: [view.text!], font: fontName, maxFontSize: 120, width: view.frame.width, height: view.frame.height))
            return view
        }()
        contentView.addSubview(text_view)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchState(_:))))
        contentView.alpha = 0.4
    }
    
    @objc private func switchState(_ gesture: UITapGestureRecognizer){
        if(enabled){
            contentView.alpha = 0.4
        }else{
            contentView.alpha = 1
        }
        enabled = !enabled
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
