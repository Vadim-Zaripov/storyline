//
//  ChooseInterestsViewController.swift
//  storyline
//
//  Created by Vadim on 02/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChooseInterestsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    var padding: CGFloat = 0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "collectionCell"
    var items = ["1", "2", "3", "4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(rgb: bgColor)//.init(white: 0.95, alpha: 1)
        padding = 0.05*view.bounds.width
        
        let top_margin = padding + UIApplication.shared.statusBarFrame.height
        let title_height = 0.07*view.bounds.height
        let titleView: UILabel = {
            let label = UILabel()
            label.text = choose_interests_title
            label.textAlignment = .center
            label.font = UIFont(name: fontName, size: FontHelper.getFontSize(strings: [label.text!], font: fontName, maxFontSize: 120, width: 0.9*view.bounds.width, height: title_height))
            label.frame = CGRect(x: 0, y: top_margin, width: view.bounds.width, height: title_height)
            return label
        }()
        view.addSubview(titleView)
        
        let bottom_margin = 2*padding
        let submitBtn: UIButton = {
            let btn = UIButton()
            btn.setTitle(save_interests, for: .normal)
            btn.frame = CGRect(x: 0, y: view.bounds.height - bottom_margin - 0.8*title_height, width: view.bounds.width, height: 0.8*title_height)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = UIFont(name: fontName, size: FontHelper.getFontSize(strings: [save_interests], font: fontName, maxFontSize: 120, width: 0.9*view.bounds.width, height: 0.8*title_height))
            btn.isUserInteractionEnabled = true
            return btn
        }()
        submitBtn.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        view.addSubview(submitBtn)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = padding
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleView.frame.maxY + padding, width: view.frame.width, height: submitBtn.frame.minY - titleView.frame.maxY - padding), collectionViewLayout: flowLayout)
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
    }
    
    @objc func submit(_ sender: UIButton){
        if (data.user == nil || data.firebase_user == nil) {return}
        data.user!.interests = []
        for i in 1..<items.count+1{
            let cell = view.viewWithTag(i) as! InterestCell
            if(cell.enabled) {data.user!.interests.append(i - 1)}
        }
        if(data.user!.interests.count == 0){
            messageAlert(for: self, message: no_interest_alert, text_error: no_interest_description)
        }else{
            uploadInterests(forUser: data.user!, toId: data.firebase_user!.uid) { (success) in
                if success{
                    self.presentInFullScreen(ViewController(), animated: true, completion: nil)
                }else{
                    messageAlert(for: self, message: error_loading_interest, text_error: error_loading_desription)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! InterestCell
        cell.tag = indexPath[1] + 1
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 3*padding) / 2
        return CGSize(width: width, height: 0.8*width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}
