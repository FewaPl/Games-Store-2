//
//  SectionCollectionViewCell.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import SDWebImage
class SectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var TheView: UIView!
    var Selected : Bool = false
    func Updata(section : SectionObject) {
        TheView.layer.cornerRadius = self.frame.size.width / 4
        if let strurl = section.Icon {
            if let url = URL(string : strurl) {
                self.ImageView.sd_setImage(with: url, completed: { (TheImage, Error, Cache, URl) in
                    if self.Selected {
                        self.ImageView.tintColor = UIColor.white
                        self.TheView.backgroundColor = UIColor(red: 97/255.0, green: 189/255.0, blue: 213/255.0, alpha: 1.0)
                    } else {
                        self.ImageView.tintColor = UIColor(red: 97/255.0, green: 189/255.0, blue: 213/255.0, alpha: 1.0)
                        self.TheView.backgroundColor = UIColor.white
                    }
                })
            }
        }
    }
    
    
    
    
}
