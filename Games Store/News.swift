//
//  News.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 23/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit

class News : UITableViewController {
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UpdateHeaderImageSize()
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.TableViewCententOffSetY = 300 - scrollView.contentOffset.y
        UpdateHeaderImageSize()
    }
    
    func UpdateHeaderImageSize() {
        var extraHeight : CGFloat = 0
        if let tabbar = tabBarController?.tabBar {
            extraHeight = tabbar.frame.size.height + 15
        }
      self.HeaderView.frame.origin.y = -TableViewCententOffSetY + 300 + extraHeight
        HeaderView.frame.size.height = TableViewCententOffSetY
        self.view.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
    }
    var TableViewCententOffSetY : CGFloat = 300
    
    
    var TheNews : NewsObject!
    @IBOutlet weak var NameLabel : UILabel!
    @IBOutlet weak var DateLabel : UILabel!
    @IBOutlet weak var SectionNameLabel : UILabel!
    @IBOutlet weak var UserNameLabel : UILabel!
    @IBOutlet weak var TextView : UITextView!
    @IBOutlet weak var HeaderView : UIView!
    @IBOutlet weak var FooterView : UIView!
    
    @IBOutlet weak var ImageView: UIImageView!
    var Images : [String] = []
    @IBOutlet weak var CollectionView : UICollectionView! {didSet {CollectionView.delegate = self ; CollectionView.dataSource = self } }
    @IBAction func CallUser(sender : XButton){
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.CollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        if let owneruserid = TheNews.OwnerUserID {
            UserAPI.GetUser(with: owneruserid)  { (User : UserObject) in
                DispatchQueue.main.async {
                 self.UserNameLabel.text = User.Name
                }
            }
        }
        
        self.NameLabel.text = TheNews.Name
        

        self.DateLabel.text = TheNews.Stamp?.ShortData()
        
       
        self.TextView.text = TheNews.Descriotion
        self.title = TheNews.Name
        
        if TheNews.Images!.count > 0 {
            if let urlstr = TheNews.Images?[0] {
                if let url = URL(string : urlstr){
                    self.ImageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
        if let imegs = TheNews.Images { self.Images = imegs }
        
        self.tableView.tableHeaderView = HeaderView
        self.tableView.tableFooterView = FooterView
        TextViewChangeSizeToFit()
    }
    func TextViewChangeSizeToFit() {
        let fixedWidth = TextView.frame.width
        TextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = TextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = TextView.frame
        newFrame.size = CGSize(width: max(newSize.width , fixedWidth), height: newSize.height)
        var THeight : CGFloat = 80
        for one in FooterView.subviews {
            if (one is UITextView) == false {
                THeight += CGFloat(one.frame.size.height)
            }
        }
        FooterView.frame.size.height = THeight + newFrame.size.height
        tableView.layoutIfNeeded()
        
    }
    
}
extension News : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        // put the image
        cell.Update(url: Images[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string : Images[indexPath.row]){
            self.ImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
    


