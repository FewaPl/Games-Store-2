//
//  SectionObject.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation
import Firebase
class SectionObject {
    
    var ID : String?
    var Name : String?
    var Stamp : TimeInterval?
    var Icon : String?
    
    init(ID : String , Name : String , Stamp : TimeInterval , Icon : String) {
        self.ID = ID
        self.Name = Name
        self.Stamp = Stamp
        self.Icon = Icon
    }
    init(Dictionary : [String : AnyObject]) {
    self.ID = Dictionary["ID"] as? String
        self.Name = Dictionary["Name"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
        self.Icon = Dictionary["Icon"] as? String
    }
    func GetDictionary() -> [String : AnyObject] {
        var new : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        new["Icon"] = self.Icon as AnyObject
        return new
    }
    func Upload() {
        guard let id = self.ID else { return }
    Database.database().reference().child("Sections").child(id).setValue(GetDictionary())
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "SectionHasbeenAdd") , object: nil)
    }
    func Remove() {
        guard let id = self.ID else { return }
        Database.database().reference().child("Sections").child(id).removeValue()
    }
}
class SectionApi {
    
    static func GetSection(completion : @escaping (_ Sections : [SectionObject]) -> ()) {
        Database.database().reference().child("Sections").observeSingleEvent(of: .value) { (Snapshot : DataSnapshot) in
            if let value = Snapshot.value as? [String : [String : AnyObject]] {
                var TSection : [SectionObject ] = []
                for one in value.values {
                    TSection.append(SectionObject(Dictionary: one))
                    if TSection.count == value.count {
                        completion(TSection)
                    }
                }
            }
        }
    
        
    }
    static func GetSection(sectionID : String ) -> SectionObject? {
     let sections = SectionCache.GetSections()
        for one in sections {
            if one.ID == sectionID {
                return one
            }
        }
        return nil
    }
}
