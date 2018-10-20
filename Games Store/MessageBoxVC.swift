//
//  MessageBox.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 16/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
class MessageBoxVC : UIViewController {
    var Text : String!
    @IBOutlet weak var label : UILabel!
    @IBAction func DoneButton (sender : XButton) {
        dismiss(animated: true , completion: nil )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = Text
    }
    
}
class MessageBox  {
    static func show (_ Text : String){
    let storyboard = UIStoryboard(name: "MessageBox", bundle: nil)
    let MBVC = storyboard.instantiateViewController(withIdentifier: "MessageBoxVC") as! MessageBoxVC
        MBVC.Text = Text
    MBVC.modalTransitionStyle = .crossDissolve
    MBVC.modalPresentationStyle = .overFullScreen
    
        UIApplication.getPresentedViewController()?.present(MBVC, animated: true, completion: nil)
    }
}

