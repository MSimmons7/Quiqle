//
//  Invitation.swift
//  Quiqle
//
//  Created by Sikander Zeb on 6/24/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit

class Invitation {
    var id: String = ""
    var group: Post!
    var message: String = ""
    var sender: UserEntity!
    var receiver: UserEntity!
    var accepted: Bool = false
    
    public init(id: String, dict: Dictionary<String, String>) {
        self.id = id
        
        if dict["group"] != nil {
            let id = dict["group"]!
            group = Utilities.shared.productsArray.filter({$0.id == id})[0]
        }
        
        if dict["message"] != nil {
            message = dict["message"] ?? ""
        }
        
        if dict["sender"] != nil {
            let id = dict["sender"]
            if  Utilities.shared.usersArray.filter({$0.id == id}).count > 0 {
                sender = Utilities.shared.usersArray.filter({$0.id == id})[0]
            }
            
        }
        
        if dict["receiver"] != nil {
            let id = dict["receiver"]
            if  Utilities.shared.usersArray.filter({$0.id == id}).count > 0 {
                receiver = Utilities.shared.usersArray.filter({$0.id == id})[0]
            }
        }
        
        if dict["accepted"] != nil {
            let accept = dict["accepted"]
            if accept == "true" {
                accepted = true
            }
            else {
                accepted = false
            }
        }
    }
}
