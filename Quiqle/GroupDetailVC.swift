//
//  ChatVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 6/14/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import BSModalPickerView
import LocationPickerViewController

class GroupDetailVC: BaseVC {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDisc: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var eventView: UIView!
    
    @IBOutlet weak var location: UIView!
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
    
    @IBAction func pickLocation(_ sender: UIButton) {
        let lp = LocationPicker()
        lp.pickCompletion = { (pickedLocationItem) in
            sender.setTitle(pickedLocationItem.name, for: .normal)
        }
        lp.addBarButtons()
        // Call this method to add a done and a cancel button to navigation bar.
        
        let nv = UINavigationController(rootViewController: lp)
        present(nv, animated: true, completion: nil)
    }
    
    @IBAction func createEvent(_ sender: UIButton) {
        location.isHidden = true
        eventView.isHidden = false
        alertViewTapped(sender)
    }
    
    @IBAction func createLocation(_ sender: UIButton) {
        location.isHidden = false
        eventView.isHidden = true
        alertViewTapped(sender)
    }
    
    @IBAction func pickDataa(_ sender: UIButton) {
        let picker = BSModalDatePickerView()
        picker.mode = .date
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
