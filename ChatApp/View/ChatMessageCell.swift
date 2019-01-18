//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Kaiserdem on 17.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
  let textView: UITextView = {
    let tv = UITextView()
    tv.text = "Text"
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(textView)
    
    textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
