//
//  Message.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class Idea: NSObject {
    
    var date: String?
    var email: String?
    var idea: String?
    var username: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        date = dictionary["date"] as? String
        email = dictionary["email"] as? String
        idea = dictionary["idea"] as? String
        username = dictionary["username"] as? String
    }
}








