//
//  HomeVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 5/31/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var `switch`: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isPickingGroup: Bool = false
    override func viewDidLoad() {
        FirebaseHelper.shared.dbref = Database.database().reference()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showAlert(_:)))
        alertView.addGestureRecognizer(gesture)
        super.viewDidLoad()
        Messaging.messaging().subscribe(toTopic: "group") { (error) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Utilities.shared.updateInvitations {
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
        
        if segue.identifier == "addFriends" {
            isPickingGroup = false
            titleLabel.text = "Pick It"
            if let vc = segue.destination as? AddPeopleVC {
                vc.post = Utilities.shared.productsArray[(table.indexPathForSelectedRow?.row)!]
            }
            return
        }
        
        if let vc = segue.destination as? GroupDetailVC {
            vc.post = Utilities.shared.productsArray[(table.indexPathForSelectedRow?.row)!]
        }
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        if alertView.isHidden {
            alertView.isHidden = false
        }
        else {
            alertView.isHidden = true
        }
    }
    
    @IBAction func addPeopleTapped(_ sender: UIButton) {
        isPickingGroup = true
        showAlert(sender)
        table.isHidden = false
        reminderTable.isHidden = true
        `switch`.selectedSegmentIndex = 0
        titleLabel.text = "Pick a group"
    }
    
    @objc func joinTapped(_ sender: UIButton) {
        let tag = sender.superview?.superview?.tag
        let invitation = Utilities.shared.invitationsArray[tag!]
        if invitation.accepted {
            
        }
        else {
            
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
        return Utilities.shared.invitationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == table {
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GenericCell
            let group = Utilities.shared.productsArray[indexPath.row]
            cell.name.text = group.name
            return cell
        }
        else {
            let invitation = Utilities.shared.invitationsArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationCell
            cell.tag = indexPath.row
            cell.name.text = invitation.group.name
            cell.desc.text = invitation.message
            if invitation.accepted {
                cell.yesButton.setTitle("Accepted", for: .normal)
            }
            else {
                cell.yesButton.addTarget(self, action: #selector(joinTapped(_:)), for: .allTouchEvents)
                
                cell.noButton.addTarget(self, action: #selector(joinTapped(_:)), for: .allTouchEvents)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == table && isPickingGroup {
            self.showAlert(UIButton())
            self.performSegue(withIdentifier: "addFriends", sender: self)
        }
        else if tableView == table {
            self.performSegue(withIdentifier: "groupDetail", sender: self)
        }
    }
}
