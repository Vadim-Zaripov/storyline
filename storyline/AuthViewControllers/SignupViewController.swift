//
//  SignupViewController.swift
//  storyline
//
//  Created by Vadim on 01/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import os

var email = ""
class SignupViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {

    var signup_view: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = ""
        view.backgroundColor = .white
        signup_view = SignUpView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(signup_view)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        signup_view.submit_btn.addTarget(self, action: #selector(Register(_:)), for: .touchUpInside)
        signup_view.google_submit_btn.addTarget(self, action: #selector(googleAuth(_sender:)), for: .touchUpInside)
        
        signup_view.email_field.delegate = self
        signup_view.password_field.delegate = self
        signup_view.confirm_field.delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to log into Google: ", err)
            return
        }
        
        guard let idtoken = user.authentication.idToken else {return}
        guard let accesstoken = user.authentication.accessToken else {return}
        
        let credentials = GoogleAuthProvider.credential(withIDToken: idtoken, accessToken: accesstoken)
        
        let v = LoadingView()
        v.set(frame: view.frame)
        view.addSubview(v)
        v.show()
        
        Auth.auth().signIn(with: credentials, completion: {(result, error) in
            v.removeFromSuperview()
            if let e = error{
                print("Failed to log in Firebase using Google: ", e)
            }
            self.presentInFullScreen(ViewController(), animated: true, completion: nil)
            print("Successfully logged in Firebase", result!.user.uid)
        })
        
        print("Successfully logged into Google ", user!)
    }
    
    @objc func googleAuth(_sender: Any){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func Register(_ sender: Any) {
        if(signup_view.email_field.text == "" || signup_view.password_field.text == "" || signup_view.confirm_field.text == ""){return}
        if(signup_view.password_field.text! == signup_view.confirm_field.text!){
            view.isUserInteractionEnabled = false
            let v = LoadingView()
            v.set(frame: view.frame)
            view.addSubview(v)
            v.show()
            email = signup_view.email_field.text!
            Auth.auth().createUser(withEmail: signup_view.email_field.text!, password: signup_view.password_field.text!) { authResult, error in
                self.view.layer.removeAllAnimations()
                self.view.isUserInteractionEnabled = true
                v.removeFromSuperview()
                if error != nil{
                    messageAlert(for: self, message: error_title, text_error: error_texts_sign_up[1])
                    return
                }
                data.firebase_user = Auth.auth().currentUser!
                setupUser(withId: Auth.auth().currentUser!.uid, completion: nil)
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    os_log("Error while sending verification email")
                    messageAlert(for: self, message: error_title, text_error: error_texts_sign_up[2])
                    return
                }
                do{
                    try Auth.auth().signOut()
                    let alert = UIAlertController(title: verification_sent_text, message: verification_sent_describtion, preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: alert_ok, style: UIAlertAction.Style.default, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.presentInFullScreen(LogInViewController(), animated: true, completion: nil)
                    }))
                    self.presentInFullScreen(alert, animated: true, completion: nil)
                }catch _ as NSError{
                    messageAlert(for: self, message: error_title, text_error: error_texts_sign_up[1])
                    os_log("error")
                }
                
            }
        }else{
            messageAlert(for: self, message: error_title, text_error: error_texts_sign_up[0])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signup_view.email_field.resignFirstResponder()
        signup_view.password_field.resignFirstResponder()
        signup_view.confirm_field.resignFirstResponder()
        return true
    }

}
