//
//  HomeVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 5/31/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeVC: UIViewController {

    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        FirebaseHelper.shared.dbref = Database.database().reference()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Utilities.shared.updateProducts {
            self.table.reloadData()
        }
    }
    
    @IBAction func changeTab(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            reminderTable.isHidden = true
            table.isHidden = false
        }
        else {
            reminderTable.isHidden = false
            table.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GroupDetailVC {
            vc.post = Utilities.shared.productsArray[(table.indexPathForSelectedRow?.row)!]
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            return 114
        }
        else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if table == tableView {
            return Utilities.shared.productsArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GenericCell
        let group = Utilities.shared.productsArray[indexPath.row]
        cell.name.text = group.name
        return cell
    }
}
