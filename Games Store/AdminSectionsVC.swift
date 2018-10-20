//
//  AdminSectionsVC.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 26/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit

class AdminSectionVC : UIViewController {
    
    var Sections : [SectionObject] = [] {
        didSet {
        Sections = Sections.sorted(by: {
            guard let one = $0.Stamp , let two = $1.Stamp else {return true}
            return one > two
        })
        }}
    
    @IBOutlet weak var TableView : UITableView! { didSet { TableView.delegate = self ; TableView.dataSource = self } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: "AdminSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        SetUpRefresh()
        GetData()
        NotificationCenter.default.addObserver(self, selector: #selector(AdminSectionVC.RestartVC), name: NSNotification.Name(rawValue: "SectionHasbeenAdd"), object: nil)
    }
    func GetData (){
        SectionApi.GetSection {( Sections : [SectionObject]) in
            self.Sections = Sections
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
        }
    }

lazy var refreshControl: UIRefreshControl = {
   let refreshController = UIRefreshControl()
    refreshController.addTarget(self, action: #selector(AdminSectionVC.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    refreshController.tintColor = UIColor.blue
    return refreshController
} ()
@objc func handleRefresh(_ refreshControl: UIRefreshControl) { RestartVC() ; refreshControl.endRefreshing()}
func SetUpRefresh() { self.TableView.addSubview(self.refreshControl) }
@objc func RestartVC () { Sections = [] ; TableView.reloadData() ; GetData()}
}
extension AdminSectionVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AdminSectionTableViewCell
        cell.Updata(Section: Sections[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.Sections[indexPath.row].Remove()
            self.Sections.remove(at: indexPath.row)
            self.TableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}














