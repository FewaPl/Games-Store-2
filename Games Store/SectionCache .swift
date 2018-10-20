//
//  SectionCache .swift
//  Games Store
//
//  Created by فارس محمد الحربي on 03/09/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import Foundation

class SectionCache {
    
    static func AddSections(sections : [SectionObject]) {
        var Icons : [String] = []
        var IDs : [String] = []
        var Names : [String] = []
        
        sections.forEach { (One) in
            if let icon = One.Icon {
                Icons.append(icon)
            }
        }
        sections.forEach { (One) in
            if let name = One.Name {
                IDs.append(name)
            }
        }
        sections.forEach { (One) in
            if let id = One.ID {
                Names.append(id)
            }
        }
        
        UserDefaults.standard.setValue(Icons, forKey: "Icons")
        UserDefaults.standard.setValue(IDs, forKey: "IDs")
        UserDefaults.standard.setValue(IDs, forKey: "Names")
    }
    
  static func GetSections()-> [SectionObject] {
        guard let Icons = UserDefaults.standard.value(forKey: "Icons") as? [String] , let IDs = UserDefaults.standard.value(forKey: "IDs") as? [String] , let Names = UserDefaults.standard.value(forKey: "Names") as? [String] else { return []}
        var TSections : [SectionObject] = []
        for (index , one ) in Icons.enumerated() {
            let newSections = SectionObject(ID: IDs[index], Name: Names[index], Stamp: 0, Icon: one)
            TSections.append(newSections)
        }
        return TSections
    }
}
