//
//  LoginViewController.swift
//  storyline
//
//  Created by Vadim on 01/05/2020.
//  Copyright © 2020 Vadim Zaripov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import os

class LogInViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
    var login_view: LogInView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        view.backgroundColor = .white
        login_view = LogInView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        view.addSubview(login_view)
        
        login_view.google_submit_btn.addTarget(self, action: #selector(googleAuth(_sender:)), for: .touchUpInside)
        
        
        login_view.submit_btn.addTarget(self, action: #selector(LogIn(_:)), for: .touchUpInside)
        login_view.forgot_btn.addTarget(self, action: #selector(Reset(_:)), for: .touchUpInside)
        login_view.sign_up_btn.addTarget(self, action: #selector(toSignUp(_:)), for: .touchUpInside)
        
        login_view.email_field.text = email

        login_view.email_field.delegate = self
        login_view.password_field.delegate = self
    }
    
    @objc func googleAuth(_sender: Any){
        GIDSignIn.sharedInstance()?.signIn()
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
    
    @objc func LogIn(_ sender: Any) {
        if(login_view.email_field.text == "" || login_view.password_field.text == ""){return}
        os_log("HELLO")
        view.isUserInteractionEnabled = false
        let v = LoadingView()
        v.set(frame: view.frame)
        view.addSubview(v)
        v.show()
        login_view.forgot_btn.isEnabled = true
        Auth.auth().signIn(withEmail: login_view.email_field.text!, password: login_view.password_field.text!, completion: { (u, err) in
            self.view.layer.removeAllAnimations()
            self.view.isUserInteractionEnabled = true
            v.removeFromSuperview()
            if let error = err{
                let err_code = AuthErrorCode(rawValue: error._code)
                switch err_code{
                case .wrongPassword?:
                    messageAlert(for: self, message: error_title, text_error: error_texts[0])
                case .invalidEmail?:
                    messageAlert(for: self, message: error_title, text_error: error_texts[1])
                default:
                    messageAlert(for: self, message: error_title, text_error: error_texts[2])
                }
            }else{
                os_log("NO ERROR")
                data.firebase_user = Auth.auth().currentUser!
                if(data.firebase_user!.isEmailVerified){
                    loadUser(withId: data.firebase_user!.uid) { (user) in
                        data.user = user
                        if let user = user{
                            if(user.interests.count == 0){
                                self.presentInFullScreen(ChooseInterestsViewController(), animated: true, completion: nil)
                            }else{
                                self.presentInFullScreen(ViewController(), animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                    messageAlert(for: self, message: error_title, text_error: error_texts[3])
                }
            }
        })
    }
    
    @objc func Reset(_ sender: Any) {
        if(login_view.email_field.text != ""){
            Auth.auth().sendPasswordReset(withEmail: login_view.email_field.text!, completion: nil)
            login_view.forgot_btn.isEnabled = false
            messageAlert(for: self, message: reset_password_title, text_error: reset_password_describtion)
        }
    }
    
    @objc func toSignUp(_ sender: Any){
        presentInFullScreen(SignupViewController(), animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        login_view.email_field.resignFirstResponder()
        login_view.password_field.resignFirstResponder()
        return true
    }
}
