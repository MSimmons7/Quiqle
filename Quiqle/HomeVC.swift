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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
}
