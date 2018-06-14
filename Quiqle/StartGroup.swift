//
//  StartGroup.swift
//  Quiqle
//
//  Created by Sikander Zeb on 6/14/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import SVProgressHUD

class StartGroup: BaseVC {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var search: UITextField!
    
    @IBOutlet weak var table: UITableView!
    var filteredUsers:[UserEntity] = []
    var selectedUsers: [UserEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredUsers = Utilities.shared.usersArray
    }
    
    @IBAction func textfieldDidChange(_ textfield: UITextField ) {
        if (textfield.text?.count)! > 0 {
            filteredUsers = Utilities.shared.usersArray.filter({$0.name.contains(textfield.text!) || $0.email.contains(textfield.text!)})
        }
        else {
            filteredUsers = Utilities.shared.usersArray
        }
        table.reloadData()
    }
    
    @IBAction func createGroup(_ sender: UIButton) {
        
        if selectedUsers.count < 1 || Utilities.isEmpty(name.text!) {
            Utilities.showAlert(self, message: "Please select users and enter group name", alertTitle: "Missing data")
            return
        }
        
        let ids = selectedUsers.map{$0.id}.joined(separator: ",")
        let group = ["name":name.text ?? "",
                     "users":ids,
                     "desc":"desc"]
        
        SVProgressHUD.show()
        FirebaseHelper.shared.dbref.child("groups").childByAutoId().setValue(group) { (error, dbref) in
            SVProgressHUD.dismiss()
            
            if error != nil {
                Utilities.showAlert(self, message: "Error adding group \(error?.localizedDescription ?? "")", alertTitle: "Error")
                return
            }
            
            Utilities.shared.updateProducts(completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
}

extension StartGroup: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GenericCell
        let user = filteredUsers[indexPath.row]
        cell.name.text = user.name
        if selectedUsers.contains(where: {$0.id == user.id}) {
            cell.yesButton.isHidden = false
        }
        else {
            cell.yesButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.row]
        if selectedUsers.contains(where: {$0.id == user.id}) {
            selectedUsers.remove(at: selectedUsers.index(where: {$0.id == user.id})!)
        }
        else {
            selectedUsers.append(user)
        }
        table.reloadData()
    }
}

