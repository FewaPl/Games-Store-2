//
//  ResetPassword.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 16/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import FirebaseAuth
class ResetPassword : UIViewController {
    
    
    
    @IBOutlet weak var EmailText: XTextField!
    @IBAction func ResetPasswordButton(_ sender: XButton) {
        guard let email = EmailText.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) { (Error) in
            if let error = Error {
             MessageBox.show(FirError.Error(Code: error._code))
            } else {
                MessageBox.show("تم ارسال استعادة كلمة السر الى بريدك الالكتروني")
                self.EmailText.text = ""
            }
        }
    }
    
    
    
    
    
    
    
    ////////////////
    @IBOutlet weak var Layout: NSLayoutConstraint!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingUpKeyboardNotificaions()
        
    }
    
}
extension ResetPassword {
    func SettingUpKeyboardNotificaions(){
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPassword.KeyboardShow(Notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPassword.KeyboardHid(Notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func KeyboardShow (Notification: NSNotification) {
        if let keyboardSize = (Notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            UIView.animate(withDuration: 0.3 , delay: 0 , options: [], animations: {[weak self] in
                self?.Layout.constant = keyboardSize.height + 8
                self?.view.layoutIfNeeded()
                }, completion: nil )
        }
    }
    @objc func KeyboardHid (Notification: NSNotification) {
        UIView.animate(withDuration: 0.3 , delay: 0 , options: [], animations: {[weak self] in
            self?.Layout.constant = 50
            }, completion: nil)
        
}
}
