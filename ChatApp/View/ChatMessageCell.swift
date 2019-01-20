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
    tv.font = UIFont.systemFont(ofSize: 16)
    tv.backgroundColor = .clear
    tv.translatesAutoresizingMaskIntoConstraints = false
    return tv
  }()
  // вю фон для сообщений
  let bubbleView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(bubbleView)
    addSubview(textView)
    
    bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    
    textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
