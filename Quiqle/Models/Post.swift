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
    var user: UserEntity? = nil
    var start: String = ""
    var end: String = ""
    var place: String = ""
    var name: String = ""
    var likes: [UserEntity] = []
    var views: [UserEntity] = []
    
    public init(id: String, dict: Dictionary<String, String>) {
        self.id = id
        
        if dict["name"] != nil {
            name = dict["name"]!
        }
        if dict["start"] != nil {
            start = dict["start"] ?? ""
        }
        if dict["end"] != nil {
            end = dict["end"]!
        }
        if dict["place"] != nil {
            place = dict["place"]!
        }
//        user = Utilities.shared.userFor(key: dict["userKey"]!)
//        if likes["likes"] != nil {
//            likes = dict["caption"]!
//        }
//        if dict["caption"] != nil {
//            caption = dict["caption"]!
//        }
//        if dict["views"] != nil {
//            views = dict["views"]!
//        }
    }
}
