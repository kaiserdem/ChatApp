//
//  UIColor.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

extension UIColor { 
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
  }
}

