//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Kaiserdem on 10.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase


class NewMessageController: UITableViewController {
  
  let cellId = "Cell"
  
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
                             // сслыка на ячейку по айди
    self.tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewMessageController.handleCancel))
    
    tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    
    fetchUser()
  }
  
  func fetchUser() { // выбрать пользователя
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let user = User(dictionary: dictionary) // пользователь
        user.id = snapshot.key
        
        self.users.append(user) // добавляем в масив
        
        DispatchQueue.main.async { // на главном потоке асинхронно
          self.tableView.reloadData()
        }
      }
    }, withCancel: nil)
  }
  
  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count

  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
    
    let user = users[indexPath.row]
    cell.textLabel?.text = user.name
    cell.detailTextLabel?.text = user.email
    
    // получить ссылку на картинку и присвоить
    if let profileImageUrl = user.profileImage {
     cell.profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
  var messagesController: MessagesController?
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true) { // закрыть
      let user = self.users[indexPath.row]// пользоватьель на кого нажали
      self.messagesController?.showChatControllerForUser(user) // показать контроллер
    }
  }
}

class UserCell: UITableViewCell {
  
  // какртинка по умолчанию
  lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "user")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 20
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)!-2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
    
    detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)!+2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    addSubview(profileImageView)
    // ставим контстрейнты
    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive  = true
    profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive  = true
    profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive  = true
    profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive  = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}
