//
//  AddNewNews.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 21/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import BSImagePicker
import FirebaseAuth

class AddNewNews : UIViewController , UITextViewDelegate , UIScrollViewDelegate , SectionDelegate {
    
    
    @IBOutlet weak var PriceTextField: XTextField!
    
    func Selected(section: SectionObject) {
        ButtonTextFiled.setTitle(section.Name, for: .normal)
    TheSction = section
    }
    var TheSction : SectionObject?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? SelectSectionVC {
        next.delegate = self
    }
    }
    @IBOutlet weak var SendButton: XButton!
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            view.endEditing(true)
        
        }
        }
    
    let vc = BSImagePickerViewController()
    
    func textViewDidChange(_ textView: UITextView) {
        TextViewChangeSizeToFit()
    }
    
    
    @IBOutlet weak var ScrollView : UIScrollView!
    @IBOutlet weak var BigView : UIView!
    @IBOutlet weak var BigViewHeight : NSLayoutConstraint!
    @IBOutlet weak var Buttomlayout : NSLayoutConstraint!
    @IBOutlet weak var NameTextField : UITextField!
    @IBOutlet weak var SectionTextField : UITextField!
    
    @IBOutlet weak var ButtonTextFiled: UIButton!
    
    @IBAction func SelectSectionAction(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var TextView : UITextView!
    @IBOutlet weak var CollectionView : UICollectionView!
    var Images : [UIImage] = []
    @IBAction func AddImages( sender : XButton){
        AddImageAction()
    }
    @IBAction func Done (sender: XButton){
        
    sender.Loading()
    Uploader.shared.Upload(Images: Images.map({$0.resize(size: 800)}))
        Uploader.shared.DidUploadAll = {
            Auth.auth().addStateDidChangeListener({ (auth, user) in
                
                if let uid = user?.uid {
                let imagesUrl = Uploader.shared.UploadedImagesURLS
                    
                    guard let name = self.NameTextField.text ,  let description = self.TextView.text , let price = self.PriceTextField.text else {return}
                    
                    NewsObject(ID: UUID().uuidString, Name: name,Price : price , Stamp: Date().timeIntervalSince1970,  OwnerUserID: uid, Descriotion: description, Images: imagesUrl, smallImage: imagesUrl[0]).Upload()
                    DispatchQueue.main.async {
                     sender.Done()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }
            })
        }
        Uploader.shared.DidFailedUpload = {
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        TextView.delegate = self
        TextView.isScrollEnabled = false
        ScrollView.delegate = self
        CollectionView.delegate = self
        CollectionView.dataSource = self
        SettingUpKeyboardNotificaions()
        TextViewChangeSizeToFit()
    }
    func TextViewChangeSizeToFit() {
        let fixedWidth = TextView.frame.width
        TextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = TextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = TextView.frame
        newFrame.size = CGSize(width: max(newSize.width , fixedWidth), height: newSize.height)
        var THeight : CGFloat = 200
        for one in BigView.subviews {
            if (one is UITextView) == false {
                THeight += CGFloat(one.frame.size.height)
            }
        }
        BigViewHeight.constant = THeight + newFrame.size.height
        ScrollView.layoutIfNeeded()
    
    }
    
}
import Photos
// Add image
extension AddNewNews {
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
            for one in imageArray{
                if one != nil {
                    self.Images.append(one!)
                }
                DispatchQueue.main.async {
                    self.CollectionView.reloadData()
                }
                
            }
        }, completion: nil)
    }
}


//CollectionView
extension AddNewNews : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        cell.Update(Image: Images[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

// Keyboard
extension AddNewNews {
    func SettingUpKeyboardNotificaions(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewNews.KeyboardShow(Notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewNews.KeyboardHid(Notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    ///////////
    @objc func KeyboardShow (Notification: NSNotification) {
        if let keyboardSize = (Notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var newHeight : CGFloat = 0
            if let tabbar = self.tabBarController {
                newHeight = tabbar.tabBar.frame.size.height
            }
            self.Buttomlayout.constant = keyboardSize.height - newHeight
            
            UIView.animate(withDuration: 0.5 , delay: 0 , options: [], animations: {[weak self] in
                self?.view.layoutIfNeeded()
                }, completion: nil )
        }
    }
    @objc func KeyboardHid (Notification: NSNotification) {
        UIView.animate(withDuration: 0.5 , delay: 0 , options: [], animations: {[weak self] in
            self?.Buttomlayout.constant = 0
            }, completion: nil)
        
    }
}
