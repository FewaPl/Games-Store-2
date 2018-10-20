//
//  StarterVC.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//


import UIKit
import FirebaseAuth

class StarterVC : UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (Auth , User) in
            if let user = User {
                // if there are a user
                self.performSegue(withIdentifier: "App", sender: nil)
            } else {
                // if there are no user
                self.performSegue(withIdentifier: "Auth", sender: nil)
            }
        }
    }
    
}
