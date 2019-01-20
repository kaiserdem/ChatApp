//
//  UserCell.swift
//  ChatApp
//
//  Created by Kaiserdem on 16.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
  
  var message: Message? {
    didSet {
    setupNameAndPrifileImage() // загрузка имени и картинки
      
      detailTextLabel?.text = message?.text
      
      if let seconds = message?.timestamp?.doubleValue {
        let timestampDate = Date(timeIntervalSince1970: seconds)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        timeLable.text = dateFormatter.string(from: timestampDate)
      }
    }
  }
  
  private func setupNameAndPrifileImage() { // загрузка имени и картинки
    
    if let id = message?.chatPartnerId() {
      let ref = Database.database().reference() .child("users").child(id)// достать ссылку из базы
      ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let dictionary = snapshot.value as? [String: AnyObject] { // snapshot в словарь
          self.textLabel?.text = dictionary["name"] as? String // достаем из словаря имя
                       // достаем Url из картинки
          if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            // загружаем картинку из кеша
            self.profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
          }
        }
      }, withCancel: nil)
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    
    textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
    
    detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
  }
  
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 24
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let timeLable: UILabel = {
    let lable = UILabel()
   // lable.text = "HH:MM:SS"  // формат
    lable.font = UIFont.systemFont(ofSize: 12)
    lable.textColor = UIColor.darkGray
    lable.translatesAutoresizingMaskIntoConstraints = false
    return lable
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    addSubview(profileImageView)
    addSubview(timeLable)
    
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive  = true
    profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive  = true
    profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive  = true
    profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive  = true
    
    timeLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    timeLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
    timeLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
    timeLable.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

