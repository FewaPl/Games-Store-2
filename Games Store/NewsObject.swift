//
//  NewsObject.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation
import Firebase

class NewsObject {
    
    var ID : String?
    var Name : String?
    var Stamp : TimeInterval?
   // var SectionID : String?
    var OwnerUserID : String?
    var Descriotion : String?
    var Images : [String]?
    var smallImage : String?
    var Price : String?
    
    init(ID : String , Name : String , Price : String , Stamp : TimeInterval,  OwnerUserID : String, Descriotion : String, Images : [String], smallImage : String) {
        self.ID = ID
         self.Name = Name
         self.Price = Price
         self.Stamp = Stamp
        
         self.OwnerUserID = OwnerUserID
         self.Descriotion = Descriotion
         self.Images = Images
         self.smallImage = smallImage
        
    }
    init(Dictionary : [String : AnyObject]) {
        self.ID = Dictionary ["ID"] as? String
        self.Name = Dictionary ["Name"] as? String
        self.Stamp = Dictionary ["Stamp"] as? TimeInterval
       
        self.OwnerUserID = Dictionary ["OwnerUserID"] as? String
        self.Descriotion = Dictionary ["Descriotion"] as? String
        self.Images = Dictionary ["Images"] as? [String]
        self.smallImage = Dictionary ["smallImage"] as? String
        self.Price = Dictionary ["Price"] as? String
    }
    
    func GetDictionary() -> [String : AnyObject] {
        var new : [String : AnyObject ] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        
        new["OwnerUserID"] = self.OwnerUserID as AnyObject
        new["Descriotion"] = self.Descriotion as AnyObject
        new["Images"] = self.Images as AnyObject
        new["smallImage"] = self.smallImage as AnyObject
        new["Price"] = self.Price as AnyObject
        return new
    }
    func Upload() {
        
        guard let id = self.ID , let userid = self.OwnerUserID   else {return}
        Database.database().reference().child("Proudcts").child(id).setValue(GetDictionary())
      Database.database().reference().child("UserProudcts").child(userid).child(id).setValue(Date().timeIntervalSince1970)
    Database.database().reference().child("SectionsProfucts").child(id).setValue(Date().timeIntervalSince1970)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Proudctsadd"), object: nil)
    }
    func Remove() {
        guard let id = self.ID , let userid = self.OwnerUserID   else {return}
        Database.database().reference().child("Proudcts").child(id).removeValue()
        Database.database().reference().child("UserProudcts").child(userid).child(id).removeValue()
        Database.database().reference().child("SectionsProfucts").child(id).removeValue()
     }
}
    class NewsApi {
        static func GetAllNews(LastStamp : TimeInterval? , completion : @escaping (_ News : [NewsObject])->()) {
            var Ref : DatabaseQuery = Database.database().reference()
            if LastStamp == nil {
                Ref = Database.database().reference().child("Proudcts").queryLimited(toLast: 20).queryOrdered(byChild: "Stamp")
            } else {
                 Ref = Database.database().reference().child("Proudcts").queryLimited(toLast: 20).queryOrdered(byChild: "Stamp").queryEnding(atValue: LastStamp! - 0.0000000000001)
            }
            Ref.removeAllObservers()
            
            Ref.observeSingleEvent(of: .value) { (Snapshot : DataSnapshot) in
                if let dictionary = Snapshot.value as? [String : [String : AnyObject]] {
                    var TNews : [NewsObject] = []
                    for one in dictionary.values {
                        TNews.append(NewsObject(Dictionary: one))
                        if TNews.count == dictionary.count {
                            completion(TNews)
                        }
                    }
                }
            }
        }
        static func GetProductaFor(Section : SectionObject , LastStamp : TimeInterval? , completion : @escaping (_ News : [NewsObject])->()){
            guard let id = Section.ID else {return}
            var Ref : DatabaseQuery = Database.database().reference()
            if LastStamp == nil {
               Ref = Database.database().reference().child("SectionsProfucts").child(id).queryLimited(toLast: 20).queryOrderedByValue()
            } else {
              Ref =  Database.database().reference().child("SectionsProfucts").child(id).queryLimited(toLast: 20).queryOrderedByValue().queryEnding(atValue: LastStamp! - 0.0000000000001)
            }
            Ref.removeAllObservers()
            Ref.observeSingleEvent(of: .value) { (Snapshot : DataSnapshot) in
                if let value = Snapshot.value as? [String : AnyObject]{
                    var TProduct : [NewsObject] = []
                    for idForproducts in value.keys {
                        GetProductFrom(ID: idForproducts, comletion: { (product : NewsObject) in
                            TProduct.append(product)
                            if TProduct.count == value.count {
                                completion(TProduct)
                            }
                        })
                    }
                }
            }
        }
        
        static func GetProductFrom(ID : String , comletion : @escaping(_ Product : NewsObject)-> ()) {
            Database.database().reference().child("Proudcts").child(ID).observeSingleEvent(of: .value) { (Snapshot :DataSnapshot) in
                if let value = Snapshot.value as? [String : AnyObject] {
                    comletion(NewsObject(Dictionary: value))
                    
                }
            }
        }
    }

