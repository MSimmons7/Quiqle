//
//  HomeVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 5/31/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities.shared.updateProducts {
            self.table.reloadData()
        }
    }
    
    @IBAction func changeTab(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            table.isHidden = true
        }
        else {
            table.isHidden = false
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
}
