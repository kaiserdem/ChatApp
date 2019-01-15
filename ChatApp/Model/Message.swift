//
//  Message.swift
//  ChatApp
//
//  Created by Kaiserdem on 15.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class Message: NSObject {
  
  var fromId: String?
  var text: String?
  var timesTemp: NSNumber?
  var toId: String?
  
  init(dictionary: [String: Any]) {
    self.fromId = dictionary["fromId"] as? String
    self.text = dictionary["text"] as? String
    self.toId = dictionary["toId"] as? String
    self.timesTemp = dictionary["timesTemp"] as? NSNumber
  }
}
