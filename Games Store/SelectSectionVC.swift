//
//  SelectSectionVC.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit


protocol SectionDelegate {
    func Selected(section : SectionObject)
}
class SelectSectionVC : UIViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegate : SectionDelegate!
    
    var Sections : [SectionObject] = [] {
        didSet {
            Sections = Sections.sorted(by:
                {
                    guard let one = $0.Stamp , let two = $1.Stamp else {return true}
                    return one > two
            })
        }}
    
    @IBOutlet weak var TableView : UITableView! { didSet { TableView.delegate = self ; TableView.dataSource = self } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: "AdminSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        GetData()
       
    }
    func GetData (){
        SectionApi.GetSection {( Sections : [SectionObject]) in
            self.Sections = Sections
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        }
    }
}
extension SelectSectionVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminSectionTableViewCell
        cell.Updata(Section: Sections[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.Selected(section: Sections[indexPath.row])
        dismiss(animated: true, completion: nil )
    }
    
}

