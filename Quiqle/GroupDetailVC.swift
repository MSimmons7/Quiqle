//
//  ChatVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 6/14/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import BSModalPickerView

class GroupDetailVC: UIViewController {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDisc: UILabel!
    @IBOutlet weak var alertView: UIView!
    
    var post: Post!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(alertViewTapped(_:)))
        alertView.addGestureRecognizer(tapgesture)
        
        groupName.text = post.name
        groupDisc.text = post.desc
    }

    @IBAction func alertViewTapped(_ sender: UIButton) {
        if alertView.isHidden  {
            alertView.isHidden = false
        }
        else {
            alertView.isHidden = true
        }
    }
    
    @IBAction func pickDataa(_ sender: UIButton) {
        let picker = BSModalDatePickerView()
        let df = DateFormatter()
        df.dateStyle = .short
        picker.picker.tintColor = UIColor.white
        picker.tintColor = UIColor.white
        picker.picker.backgroundColor = UIColor.white
        picker.present(in: alertView) { (select) in
            if select {
                sender.setTitle("\(df.string(from: picker.selectedDate))", for: .normal)
            }
        }
        
    }
}

extension GroupDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GenericCell
        let user = post.users[indexPath.row]
        cell.name.text = user.name
        return cell
    }
}
