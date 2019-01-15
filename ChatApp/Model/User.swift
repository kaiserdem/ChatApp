//
//  User.swift
//  ChatApp
//
//  Created by Kaiserdem on 10.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class User: NSObject {
  
  var id: String?
  var name: String?
  var email: String?
  var profileImage: String?
  
  init(dictionary: [String: AnyObject]) {
    self.id = dictionary["id"] as? String
    self.name = dictionary["name"] as? String
    self.email = dictionary["email"] as? String
    self.profileImage = dictionary["profileImageUrl"] as? String
    
  }
}

