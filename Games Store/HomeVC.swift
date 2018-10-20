//
//  AppVC.swift
//  Games Store
//
//  Created by فارس محمد الحربي on 17/08/1439 AH.
//  Copyright © 1439 faris. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeVC : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var selectedIndex : Int = 0
    var Sections : [SectionObject] = [] {
        didSet {
            Sections = Sections.sorted(by:
                {
                    guard let one = $0.Stamp , let two = $1.Stamp else {return true}
                    return one < two
            })
        }}
    
    @IBOutlet weak var tableView: UITableView! { didSet { tableView.delegate = self ; tableView.dataSource = self }}
    
    @IBOutlet var SectionCollectionView: UIView!
    @IBOutlet weak var CollectionView: UICollectionView! { didSet { CollectionView.delegate = self ; CollectionView.dataSource = self } }
    
    var IsAdmin : Bool = false
    
    @IBAction func SignOutButton(_ sender: UIBarButtonItem) {
    try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    var Newss : [NewsObject] = [] { didSet {Newss = Newss.sorted(by: {
        $0.Stamp! > $1.Stamp!
        
    })}}
    var RefreshController : UIRefreshControl!
    
    func GetSection() {
        self.Sections = SectionCache.GetSections()
        self.CollectionView.reloadData()
        if self.Sections.count > 0 && self.SelectedSection == nil {
            self.SelectedSection = self.Sections[0]
        }
        SectionApi.GetSection { (sections : [SectionObject]) in
            self.Sections = sections
            if self.Sections.count > 0 && self.SelectedSection == nil {
                self.SelectedSection = self.Sections[0]
            }
            SectionCache.AddSections(sections: self.Sections)
            DispatchQueue.main.async { self.CollectionView.reloadData()  }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Admin.IsAdmin {
            self.IsAdmin = true
            DispatchQueue.main.async { self.tableView.reloadData()}
        }
        
        
 tableView.register(UINib(nibName: "NewsCellsTableViewCell", bundle : nil), forCellReuseIdentifier: "Cell")
        
//        CollectionView.register(UINib(nibName: "SectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
//       GetSection()
        GetAllData()
       // GetData()
       
        RefreshController = UIRefreshControl()
        RefreshController.addTarget(self, action: #selector(HomeVC.refrshAction), for: .valueChanged)
        RefreshController.tintColor = UIColor.blue
        tableView.addSubview(RefreshController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.refrshAction), name: NSNotification.Name(rawValue: "Proudctsadd"), object: nil)
    }
    @objc func refrshAction () {
        Newss = []
        tableView.reloadData()
        GetData()
    }
    var SelectedSection : SectionObject?
    func GetData() {
        guard let section = SelectedSection  else { GetAllData () ; return }
        NewsApi.GetProductaFor(Section: section, LastStamp: Newss.count > 0 ? Newss[Newss.count - 1].Stamp : nil) { (news : [NewsObject]) in
            self.Newss = news
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshController.endRefreshing()
            }
        }
        
    }
    
    
    func GetAllData (){
        NewsApi.GetAllNews(LastStamp: Newss.count > 0 ? Newss[Newss.count - 1].Stamp : nil) { (news : [NewsObject]) in
            self.Newss = news
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.RefreshController.endRefreshing()
            }
        }
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Newss.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NewsCellsTableViewCell
        cell.Updata(News: Newss[indexPath.row])
        
        cell.transform = CGAffineTransform(translationX: self.view.frame.size.width, y: 0)
        UIView.animate(withDuration: 0.3, delay: TimeInterval(indexPath.row) * 0.3, options: [], animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: nil)
        
        cell.ImageAntimationBlock = {
            cell.ImageView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            UIView.animate(withDuration: 0.3, delay:TimeInterval(indexPath.row) * 0.5, options: [], animations: {
                cell.ImageView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return IsAdmin
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Newss[indexPath.row].Remove()
            Newss.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowD", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? News {
            if let indexrow = sender as? Int {
                next.TheNews = Newss[indexrow]
             }
        }
    }

}
 extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Sections.count
    }
    
   //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SectionCollectionViewCell
        cell.Selected = (selectedIndex == indexPath.row)
        cell.Updata(section: Sections[indexPath.row])
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selectedIndex = indexPath.row
//        self.SelectedSection = Sections[indexPath.row]
//        refrshAction()
//        self.CollectionView.reloadData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height * 1.5, height: collectionView.frame.size.height )
    }
    
    
}
