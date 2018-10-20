//
//  NewsCellsTableViewCell.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCellsTableViewCell: UITableViewCell {

    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var NameLabel : UILabel!
    @IBOutlet weak var DescriptionLabel : UILabel!
    @IBOutlet weak var ImageView : UIImageView!
    @IBOutlet weak var Date : UILabel!
    @IBOutlet weak var Loading : UIActivityIndicatorView!
    
    func Updata (News : NewsObject) {
        self.NameLabel.text = News.Name
        self.DescriptionLabel.text = News.Descriotion
        self.PriceLabel.text = News.Price
        
        Loading.startAnimating()
        if let urlImage = News.smallImage {
            if let url = URL (string: urlImage) {
                self.ImageView.sd_setImage(with: url, completed: { (Image, Error, Cache, url) in
                    
                    self.ImageAntimationBlock?()
                    self.Loading.stopAnimating()
                })
             }
        }
        self.Date.text = News.Stamp?.GetTimeAgo()
    }
    var ImageAntimationBlock : (()->())?
}

