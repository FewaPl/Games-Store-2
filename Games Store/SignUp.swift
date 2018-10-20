//
//  SignUp.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 15/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignUp : UIViewController {
    
    @IBOutlet weak var UserNameText: XTextField!
    @IBOutlet weak var EmailText: XTextField!
    @IBOutlet weak var PasswordText: XTextField!
    
    @IBAction func CreateAccount(_ sender: XButton) {
        
        guard let email = EmailText.text , let password = PasswordText.text , let name = UserNameText.text else { return }
        if name == "" {
            MessageBox.show("الرجاء اكمال المعلومات")
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(User , Error) in
            if let error = Error {
             MessageBox.show(FirError.Error(Code: error._code))
                return
            }
            
            if let user = User {
            UserObject(ID: user.uid, Name: name, Age: nil, Job: nil, Email: email, Stamp: nil, ProfileImage: nil).Upload()
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            
            
            
            
        })
        
        
    }
    
    
    
    ////////////////////////////////////////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   @IBOutlet weak var layoutbutton: NSLayoutConstraint!
    
    @IBAction func ToLogin(_ sender: XButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingUpKeyboardNotificaions()
    }
}

extension SignUp {
    func SettingUpKeyboardNotificaions(){
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.KeyboardShow(Notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUp.KeyboardHid(Notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

















