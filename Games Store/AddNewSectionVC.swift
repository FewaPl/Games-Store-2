//
//  AddNewSectionVC.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import BSImagePicker
class AddNewSectionVC: UIViewController {
    
    
    @IBOutlet weak var LoadingIndictor: UIActivityIndicatorView!
    
   @IBOutlet weak var ButtonLayout : NSLayoutConstraint!
    let vc = BSImagePickerViewController()
    
    @IBOutlet weak var TextField : UITextField!
    @IBOutlet weak var ImageView : UIImageView!
    @IBAction func GetImage (sender : XButton){
     AddImageAction()
    }
    @IBAction func SendSection (sender : XButton){
        self.LoadingIndictor.startAnimating()
        ImageView.image?.Upload(Completion: { (theURL : String?) in
            guard let url = theURL else { return }
            SectionObject(ID: UUID().uuidString, Name: self.TextField.text!, Stamp: Date().timeIntervalSince1970, Icon: url ).Upload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.maxNumberOfSelections = 1
        SettingUpKeyboardNotificaions()
        
    }


}

import Photos
// Add image
extension AddNewSectionVC {
    func AddImageAction()  {
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            let imageArray =  assets.map({$0.ToUIImage()})
            DispatchQueue.main.async {
                self.ImageView.image = imageArray[0]
            }
        
        }, completion: nil)
    }
}

// Keyboard
extension AddNewSectionVC {
    func SettingUpKeyboardNotificaions(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewSectionVC.KeyboardShow(Notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewSectionVC.KeyboardHid(Notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    ///////////
    @objc func KeyboardShow (Notification: NSNotification) {
        if let keyboardSize = (Notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var newHeight : CGFloat = 0
            if let tabbar = self.tabBarController {
                newHeight = tabbar.tabBar.frame.size.height
            }
            self.ButtonLayout.constant = keyboardSize.height - newHeight
            
            UIView.animate(withDuration: 0.5 , delay: 0 , options: [], animations: {[weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil )
        }
    }
    @objc func KeyboardHid (Notification: NSNotification) {
        UIView.animate(withDuration: 0.5 , delay: 0 , options: [], animations: {[weak self] in
            self?.ButtonLayout.constant = 0
            }, completion: nil)
        
    }
}


