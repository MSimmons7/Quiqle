//
//  AddPeopleVC.swift
//  Quiqle
//
//  Created by Sikander Zeb on 6/24/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class AddPeopleVC: UIViewController {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDisc: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var post: Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        groupName.text = post.name
        groupDisc.text = post.desc
    }

}

extension AddPeopleVC: UITableViewDelegate, UITableViewDataSource {
    
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
        if user.invited {
            cell.yesButton.text = "Invited"
            cell.yesButton.backgroundColor = UIColor.red
        }
        else {
            cell.yesButton.text = "Invite"
            cell.yesButton.backgroundColor = UIColor.green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = post.users[indexPath.row]
        if !user.invited {
            user.invited = true
            tableView.reloadData()
            
            let u = Auth.auth().currentUser
            let invitation = ["group":post.id,
                              "sender":u?.uid,
                              "receiver":/*user.id*/u?.uid,
                              "accepted":"false",
                              "message":"You have been invited to join \(post.name)"]
            
            SVProgressHUD.show()
            FirebaseHelper.shared.dbref.child("invitations").childByAutoId().setValue(invitation) { (error, dbref) in
                SVProgressHUD.dismiss()
                
                if error != nil {
                    Utilities.showAlert(self, message: "Error inviting user \(error?.localizedDescription ?? "")", alertTitle: "Error")
                    return
                }
                
                Utilities.shared.updateInvitations {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } //block closed
        } // if closed
    }
}
