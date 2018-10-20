//
//  ImageCollectionViewCell.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 21/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ImageView : UIImageView!
    @IBOutlet weak var Loading : UIActivityIndicatorView!
    
    func Update(Image : UIImage) {
        self.ImageView.image = Image
    }
    func Update(url : String) {
        Loading.startAnimating()
        if let TheURL = URL(string : url){
            self.ImageView.sd_setImage(with: TheURL, completed: { (TheImage, Error, Cache, URl) in
                self.Loading.stopAnimating()
            })
        }
    }
}
