//
//  XUI.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 14/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import Foundation
extension UIView {
    
    @IBInspectable var CornerRadius : CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var BorderColor : UIColor {
        get { return UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var BorderWidth : CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
}




extension UIViewController {
    func OpenVC(SBN : String , VCN : String , TransitionStyle : UIModalTransitionStyle , PresentationStyle : UIModalPresentationStyle , From : UIViewController) {
        let AppVC = ASCut.MKVC(SBN: SBN, VCN: VCN)
        AppVC.modalTransitionStyle = TransitionStyle
        AppVC.modalPresentationStyle = PresentationStyle
        From.present(AppVC, animated: true, completion: nil)
    }
}

class XButton : UIButton {
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        FirstColor = UIColor(red: 234.0/255.0, green: 144.0/255.0, blue: 76.0/255.0, alpha: 1.0)
//        SecondColor = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
//        self.tintColor = UIColor.white
//        self.setTitleColor(UIColor.white, for: .normal )
//    }
    @IBInspectable var FirstColor : UIColor = UIColor.white { didSet { Update() } }
    @IBInspectable var SecondColor : UIColor = UIColor.white { didSet { Update() } }

    var gradient:CAGradientLayer = CAGradientLayer()
    func Update() {
        let colorTop = FirstColor.cgColor
        let colorBottom = SecondColor.cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        gradient.cornerRadius = 5
        gradient.zPosition = -1
        self.layer.addSublayer(gradient)
    }
    
    @IBInspectable var CircleCurves : Bool = true { didSet { CircleCurvesAction() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CircleCurvesAction()
        Update()
    }
    
    @IBInspectable var AspictFitImage : Bool = true  {
        didSet { if AspictFitImage { imageView?.contentMode = .scaleAspectFit }
        }
    }
    
    func CircleCurvesAction() {
        if CircleCurves {
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        } else {
            self.layer.cornerRadius = self.layer.cornerRadius
            
        }
    }
    
    
    var TheText : String? = ""
    var TheImage : UIImage?
    
    func Loading() {
        TheText = self.titleLabel?.text
        TheImage = self.imageView?.image
        self.setTitle("", for: .normal)
        self.setImage(#imageLiteral(resourceName: "Loading"), for: .normal)
        LoadingAnimations()
    }
    
    func LoadingAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat , .autoreverse], animations: {[weak self] in
            self?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: nil)
    }
    
    func FullCart() {
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.alpha = 0
        }) {[weak self] (Done) in
            if self == nil { return }
            self?.TheText = self!.titleLabel?.text
            self?.setTitle("", for: .normal)
            self?.setImage(#imageLiteral(resourceName: "FullCart"), for: .normal)
            self?.transform = CGAffineTransform.identity
            self?.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.3, animations: {
                self?.alpha = 1
            })
        }
        
    }
    
    func Done() {
        TheText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        self.setImage(#imageLiteral(resourceName: "Done"), for: .normal)
        self.transform = CGAffineTransform.identity
        self.layer.removeAllAnimations()
    }
    
    func Reset() {
        self.setTitle(TheText, for: .normal)
        self.setImage(TheImage, for: .normal)
        self.transform = CGAffineTransform.identity
        self.layer.removeAllAnimations()
    }
    
}

class XView  : UIView {
    
    @IBInspectable var Shadow : Bool = false {
        didSet {
            if Shadow {
                layer.shadowColor = ShadowColor.cgColor
                layer.shadowRadius = ShadowRadius
                layer.shadowOffset = CGSize.zero
                layer.shadowOpacity = 1
            }
        }
    }
    
    @IBInspectable var ShadowRadius : CGFloat = CGFloat(1.0) { didSet { layer.shadowRadius = ShadowRadius } }
    
    @IBInspectable var ShadowColor : UIColor = UIColor.black { didSet { layer.shadowColor = ShadowColor.cgColor } }
    
}

class CircleImage : XImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}

class XTapGesture : UILongPressGestureRecognizer {
    var tag : Int = 0
}

class XImageView : UIImageView {
    
    @IBInspectable var TemplateColor : UIColor = UIColor.white { didSet { UpdateColor() } }
    
    func UpdateColor() {
        self.image = self.image?.maskWithColor(color: TemplateColor)
    }
    
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}

//import PickerView
@IBDesignable class XTextField : UITextField {
    
    @IBInspectable var CircleCurves : Bool = false { didSet { CircleCurvesAction() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CircleCurvesAction()
   }
    
    func CircleCurvesAction() {
      if CircleCurves {
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    @IBInspectable var leftImage: UIImage? { didSet { updateView() } }
    @IBInspectable var leftPadding: CGFloat = 0 { didSet { updateView() } }
    @IBInspectable var rightImage: UIImage? { didSet { updateView() } }
    @IBInspectable var rightPadding: CGFloat = 0 { didSet { updateView() } }
    
    @IBInspectable var PlaceHolderColor : UIColor = UIColor.white { didSet { updateView() } }
    
   private var _isRightViewVisible: Bool = true
    
    var isRightViewVisible: Bool {
        get { return _isRightViewVisible }
        set { _isRightViewVisible = newValue ; updateView() }
    }
    
    func updateView() { setLeftImage() ; setRightImage() }
    
    var ImageSize : CGFloat = 30
    
    func setLeftImage() {
      //  leftViewMode = UITextFieldViewMode.always
        var view: UIView
        
        if let image = leftImage {
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: ImageSize * 1.5, height: ImageSize))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            //imageView.backgroundColor = UIColor.blue
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = tintColor
            
            var width = image.size.width + leftPadding
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width += 5
            }
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: ImageSize))
            view.addSubview(imageView)
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: ImageSize))
        }
        
        leftView = view
    }
    
    var Search : (()->())?
    
    @objc func SearchAction(){
        Search?()
    }
    
    func setRightImage() {
        rightViewMode = UITextFieldViewMode.always
        
        var view: UIView
        
        if let image = rightImage, isRightViewVisible {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ImageSize * 1.5, height: ImageSize))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit
            
            let tapgesture = UITapGestureRecognizer(target: self, action: #selector(XTextField.SearchAction))
            imageView.addGestureRecognizer(tapgesture)
            
            imageView.tintColor = tintColor
            
            var width = image.size.width + rightPadding
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                width += 5
            }
            
            view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: ImageSize))
            view.addSubview(imageView)
            
        } else {
            view = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding + 5, height: ImageSize))
        }
        
        rightView = view
    }
    
    
    
}

class ASCut {
    
    static func MKVC(SBN : String , VCN : String) -> UIViewController {
        let StoryBoard = UIStoryboard(name: SBN, bundle: nil)
        return StoryBoard.instantiateViewController(withIdentifier: VCN) as UIViewController
    }
    
}

import CoreGraphics
extension UIImage {
    func resize(size: CGFloat) -> UIImage {
        if self.size.width < size || self.size.height < size {
            return self
        }
        let scale = size / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: size, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0,width: size, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension UILabel {
    
    func Stroke() {
        if self.text == nil || self.text == "" { return }
        self.text = "-" + self.text! + "-"
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length ))
        self.attributedText = attributedString
    }
    
}

import Photos
extension PHAsset {
    func ToUIImage() -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: self, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        
        return presentViewController
    }
}
