//
//  Message.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var id: String?
    var text: String?
    var name: String?
    var photoUrl: String?
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        id = dictionary["id"] as? String
        text = dictionary["text"] as? String
        name = dictionary["name"] as? String
        photoUrl = dictionary["photoUrl"] as? String
        imageHeight = 200
        imageWidth = 150
        imageUrl = dictionary["imageUrl"] as? String
    }
}








