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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(rgb: bgColor)
        
        if(data.user == nil){
            return
        }
        
        let content = ProfileView(frame: view.bounds, quotes: data.quotes ?? [], user: data.user!)
        content.logout_btn.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        view.addSubview(content)
    }
    
    @objc func logOut(_ sender: Any){
        let alert = UIAlertController(title: sign_out_question, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: sign_out_text, style: UIAlertAction.Style.default, handler: {(action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "signing_out", sender: self)
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: alert_cancel, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
