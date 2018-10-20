//
//  AdminSectionTableViewCell.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit

class AdminSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var Loading: UIActivityIndicatorView!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var AdminSection: UILabel!
    
    func Updata (Section : SectionObject ) {
        Loading.startAnimating()
        self.AdminSection.text = Section.Name
        
        if let strurl = Section.Icon {
            if let url = URL(string : strurl){
                self.ImageView.sd_setImage(with: url, completed: { (TheImage, Error, Cache, URl) in
                    self.Loading.stopAnimating()
                })
            }
        }
    }
    
    
}
