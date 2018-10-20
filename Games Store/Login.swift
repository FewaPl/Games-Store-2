//
//  Login.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 16/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login : UIViewController {
    
    
    @IBOutlet weak var EmailText: XTextField!
    @IBOutlet weak var PasswordText: XTextField!
    @IBAction func LoginButton(_ sender: XButton) {
        
        guard let email = EmailText.text , let password = PasswordText.text else { return }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(User , Error) in
            if let error = Error {
                //show message
            MessageBox.show(FirError.Error(Code: error._code))
                return
            }
            //do anything
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        
    }
    
    
    
    
    
    
    ////////////////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBOutlet weak var layoutbutton: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingUpKeyboardNotificaions()
    }
}

extension Login {
    func SettingUpKeyboardNotificaions(){
        NotificationCenter.default.addObserver(self, selector: #selector(Login.KeyboardShow(Notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Login.KeyboardHid(Notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func KeyboardShow (Notification: NSNotification) {
        if let keyboardSize = (Notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            UIView.animate(withDuration: 0.3 , delay: 0 , options: [], animations: {[weak self] in
                self?.layoutbutton.constant = keyboardSize.height 
                self?.view.layoutIfNeeded()
                }, completion: nil )
        }
    }
    @objc func KeyboardHid (Notification: NSNotification) {
        UIView.animate(withDuration: 0.3 , delay: 0 , options: [], animations: {[weak self] in
            self?.layoutbutton.constant = 160
            }, completion: nil)
        
    }
    
}



