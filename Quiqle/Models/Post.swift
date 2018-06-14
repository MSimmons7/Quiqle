//
//  Post.swift
//  Tubelio
//
//  Created by Sikander Zeb on 3/13/18.
//  Copyright © 2018 Sikander. All rights reserved.
//

import UIKit

class Post {
    var id = ""
    var desc: String = ""
    var name: String = ""
    var users: [UserEntity] = []
    
    public init(id: String, dict: Dictionary<String, String>) {
        self.id = id
        
        if dict["name"] != nil {
            name = dict["name"]!
        }
        if dict["desc"] != nil {
            desc = dict["desc"] ?? ""
        }
        
        if dict["users"] != nil {
            let ids = dict["users"]?.split(separator: ",")
            for id in ids! {
                users.append(Utilities.shared.usersArray.filter({$0.id == id})[0])
            }
        }
    }
}
