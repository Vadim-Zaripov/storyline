//
//  ProfileViewController.swift
//  storyline
//
//  Created by Vadim on 04/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var content: ProfileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(rgb: bgColor)
        
        if(data.user == nil){
            return
        }
        
        content = ProfileView(frame: view.bounds, quotes: data.quotes ?? [], user: data.user!)
        content.logout_btn.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        content.back_btn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        view.addSubview(content)
        
        for quote_view in content.quotes_view.quotes_views{
            quote_view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onQuoteSelected(gesture:))))
        }
    }
    
    @objc func onQuoteSelected(gesture: UILongPressGestureRecognizer){
        if(gesture.state == .began){
            let quote = (gesture.view as! QuoteCardView).quote!
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: share_text, style: .default, handler: {(action) in
                let activityVC = UIActivityViewController(activityItems: [quote.textToShare()], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: copy_text, style: .default, handler: { (action) in
                UIPasteboard.general.string = quote.textToShare()
            }))
            
            alert.addAction(UIAlertAction(title: delete_quote, style: .destructive, handler: { (alert) in
                self.content.quotes_view.removeQuote(quote_view: gesture.view as! QuoteCardView)
                deleteQuote(forUser: data.user!, quote: quote) {(success) in
                    if success{
                        let index = data.quotes?.firstIndex(where: {$0.uid == quote.uid})
                        data.quotes?.remove(at: index!)
                    }
                }
            }))
            
            alert.addAction(UIAlertAction(title: alert_cancel, style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func back(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logOut(_ sender: Any){
        let alert = UIAlertController(title: sign_out_question, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: sign_out_text, style: UIAlertAction.Style.default, handler: {(action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                DispatchQueue.main.async {
                    self.presentInFullScreen(LogInViewController(), animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: alert_cancel, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
