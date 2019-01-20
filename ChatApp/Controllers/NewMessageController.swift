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
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
                       // сслыка на ячейку по айди
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
    if let profileImageUrl = user.profileImageUrl {
     cell.profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
  var messagesController: MessagesController?
                                      // выбрали пользователя
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true) { // закрыть
      print("Dismiss completed")
      let user = self.users[indexPath.row]// пользоватьель на кого нажали
      self.messagesController?.showChatControllerForUser(user) // показать контроллер
    }
  }
}
