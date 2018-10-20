//
//  UserObject.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation
import Firebase

class UserObject {
    var ID : String?
    var Name : String?
    var Age : Int?
    var Job : String?
    var Email : String?
    var Stamp : TimeInterval?
    var ProfileImage : String?
    
    init(ID : String , Name : String , Age : Int? , Job : String?, Email : String , Stamp : TimeInterval? , ProfileImage : String?){
        self.ID = ID
        self.Name = Name
        self.Age = Age
        self.Job = Job
        self.Email = Email
        self.Stamp = Stamp
        self.ProfileImage = ProfileImage
    }
    init (Dictionary : [String : AnyObject]) {
        self.ID = Dictionary["ID"] as? String
        self.Name = Dictionary["Name"] as? String
        self.Age = Dictionary["Age"] as? Int
        self.Job = Dictionary["Job"] as? String
        self.Email = Dictionary["Email"] as? String
        self.Stamp = Dictionary["Stamp"] as? TimeInterval
        self.ProfileImage = Dictionary["ProfileImage"] as? String
        
    }
    func GetDictionary() -> [String : AnyObject] {
        var new  : [String : AnyObject] = [:]
        new["ID"] = self.ID as AnyObject
        new["Name"] = self.Name as AnyObject
        new["Age"] = self.Age as AnyObject
        new["Job"] = self.Job as AnyObject
        new["Email"] = self.Email as AnyObject
        new["Stamp"] = self.Stamp as AnyObject
        new["ProfileImage"] = self.ProfileImage as AnyObject
        return new
        
    }
    func Upload() {
        if let id = self.ID {
            Database.database().reference().child("Users").child(id).setValue(GetDictionary())
        }
    }
    func Remove() {
        if let id = self.ID {
            Database.database().reference().child("Users").child(id).removeValue()
        }
    }
    
    
}
class UserAPI {
    private static let UsersRef = Database.database().reference().child("Users")
    static func GetUsers(LastStamp : TimeInterval? , Quantity : UInt , completin : @escaping (_ Users : [UserObject])->()) {
        var NewRef = UsersRef.queryOrdered(byChild: "Stamp").queryLimited(toLast: Quantity)
        if let laststamp = LastStamp {
            NewRef = UsersRef.queryOrdered(byChild: "Stamp").queryLimited(toLast: Quantity).queryStarting(atValue: laststamp - 0.00000001)
        }
        NewRef.observeSingleEvent(of: .value) { (Snapshot : DataSnapshot) in
            guard let Value = Snapshot.value as? [String : [String : AnyObject]] else {return}
            var TemporaryUsers : [UserObject] = []
            Value.values.forEach({
                TemporaryUsers.append(UserObject(Dictionary: $0))
                if TemporaryUsers.count == Value.count {completin(TemporaryUsers)}
            })
        }
        }
    static func GetUser(with ID : String , completion : @escaping (_ user : UserObject)->()) {
        UsersRef.child(ID).observeSingleEvent(of: .value) { (Snapshot : DataSnapshot) in
            guard let value = Snapshot.value as? [String : AnyObject] else {return}
            completion(UserObject(Dictionary: value))
            
        }
    }
}

