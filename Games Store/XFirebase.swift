//
//  XFirebase.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation
import Firebase

class Uploader {
    
    static var shared = Uploader()
    
    var DidUploadOne : (() -> ())?
    
    var DidUploadAll : (()->())?
    
    var DidFailedUpload : (()->())?
    
    var UploadedImagesURLS : [String] = []
    
    func Upload(Images : [UIImage])  {
        print(Images.count)
        UploadedImagesURLS = [] ;
        counter = 0 ;  self.Images = Images ; RecursivUploader() ; }
    
    private var Images : [UIImage] = []
    
    private var counter : Int = 0
    
    private func RecursivUploader() {
        
        if (Images.count > 0) == false { self.DidFailedUpload?() ; return }
        
        Images[counter].Upload {[weak self] (ImageURL : String?) in
            
            if self == nil { return }
            
            guard let url = ImageURL  else { self?.DidFailedUpload?() ; return }
            
            self?.UploadedImagesURLS.append(url)
            self?.DidUploadOne?()
            if self?.counter == self!.Images.count - 1 {
                self?.DidUploadAll?()
            } else {
                self?.counter += 1
                self?.RecursivUploader()
            }
            
        }
    }
    
    fileprivate func UploadInTwoSize(Image : UIImage , completion : @escaping (_ OriginalImage : String? , _ SmallImage : String? , _ ErrorMessage : String?) -> ()) {
        UploadImageToStorage(Image: Image.resize(size: 1000)) { (OriginalImageURL : String?) in
            guard let OriginalImage = OriginalImageURL else { completion(nil , nil , "Error") ; return }
            self.UploadImageToStorage(Image: Image.resize(size: 250)) { (SmallImageURL : String?) in
                guard let SmallImage = SmallImageURL else { completion(nil , nil , "Error") ; return }
                completion(OriginalImage, SmallImage, nil)
            }
        }
    }
    
    fileprivate func UploadImageToStorage(Image : UIImage , Completion : @escaping (_ ImageURL : String?)->()) {
        let metadata = StorageMetadata() ; metadata.contentType = "image/png" ; let UID = UUID().uuidString
        guard let ImageData = UIImagePNGRepresentation(Image) else {
            print(">>> Error in Converting Image To Data <<<")
            Completion(nil)
            return
        }
        _ = Storage.storage().reference().child("StoredImages").child(UID).putData(ImageData, metadata: metadata) { (meta , error) in
            if error != nil {
                print(">>> Error in uploading image data to storage <<< ")
                Completion(nil)
                return
            }
            Completion(meta?.downloadURL()?.absoluteString)
        }
    }
    
}

extension UIImage {
    
    func Upload(Completion : @escaping (_ ImageURL : String?)->()) {
        Uploader.shared.UploadImageToStorage(Image: self) { (ImageURL : String?) in
            Completion(ImageURL)
        }
    }
    
    func UploadInTwoSize(completion : @escaping (_ OriginalImage : String? , _ SmallImage : String?) -> ()) {
        Uploader.shared.UploadInTwoSize(Image: self) { (OriginalImageURL, SmallImageURL, ErrorMessage) in
            if ErrorMessage == nil {
                completion(OriginalImageURL, SmallImageURL)
            } else {
                completion(nil, nil)
            }
        }
    }
    
}



class Admin {
    static func IsAdmin(completion : @escaping ()->()) {
        Database.database().reference().child("AdminCanRead").observeSingleEvent(of: .value) {(Snapshot : DataSnapshot) in
            if Snapshot.exists() {
                // it's admin
                completion()
            }
        }
    }
}

class FirError {
    
    static func Error(Code : Int) -> String {
        
        if let TheError = AuthErrorCode(rawValue: Code) {
            
            switch TheError {
            case .emailAlreadyInUse :
                return "البريد مستعمل بالفعل."
            case .weakPassword :
                return "الرمز السري ضعيف"
            case .networkError :
                return  "حدث خطا تحقق من اتصالك بالشبكة"
            case .userNotFound :
                return  "نعتذر الحساب غير موجود او مسجل"
            case .invalidEmail :
                return "البريد الالكتروني خاطئ"
            case .wrongPassword :
                return "الرمز السري خطا"
            default :
                return "خطا غير معروف"
            }
            
        }
        
        return "خطا غير معروف"
        
    }
    
    
    
}
