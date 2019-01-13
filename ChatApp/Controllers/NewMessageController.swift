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
    fetchUser()
  }
  
  func fetchUser() { // выбрать пользователя
    
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
      if (snapshot.value as? [String: AnyObject]) != nil {
        print(snapshot)
        let user = User() // пользователь
        
        user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
        user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
        print(user.email as Any)
        print(user.name as Any)
        
        self.users.append(user) // добавляем в масив
        print(self.users.count)
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
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId)
    
    let user = users[indexPath.row]
    cell?.textLabel?.text = user.email
    cell?.detailTextLabel?.text = user.name
    return cell!
  }
}

class UserCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
}
