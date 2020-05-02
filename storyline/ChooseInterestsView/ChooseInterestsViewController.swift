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
            return btn
        }()
        view.addSubview(submitBtn)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = padding
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: titleView.frame.maxY + padding, width: view.frame.width, height: submitBtn.frame.maxY - titleView.frame.maxY - padding), collectionViewLayout: flowLayout)
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! InterestCell
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
