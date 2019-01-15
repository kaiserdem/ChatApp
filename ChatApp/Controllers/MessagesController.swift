//
//  ViewController.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(MessagesController.handelLogout))
    
    let image = UIImage(named: "edit")
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(MessagesController.handelNewMessage))
    
    checkIfUserIsLogedIn()
    
    observeMessages()
  }
  
  var messages = [Message]()
  // получает сообщения из базы
  func observeMessages() {
    let ref = Database.database().reference().child("messages") // ссылка
    ref.observe(.childAdded, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        let message = Message()
       // message.setValuesForKeys(dictionary)
        message.toId = (snapshot.value as? NSDictionary)? ["toId"] as? String ?? ""
        message.text = (snapshot.value as? NSDictionary)? ["text"] as? String ?? ""

        self.messages.append(message)
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
      print(snapshot)
    }, withCancel: nil)
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count // кол сообщений
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
    let message = messages[indexPath.row]
    cell.textLabel?.text = message.toId
    cell.detailTextLabel?.text = message.text
    
    return cell
  }
  @objc func handelNewMessage() {
    let newMessageController = NewMessageController()
    newMessageController.messagesController = self
    let navController = UINavigationController(rootViewController: newMessageController)
    present(navController, animated: true, completion: nil)
  }
  
  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему

    if Auth.auth().currentUser == nil { // если мы не вошли
      perform(#selector(handelLogout), with: nil, afterDelay: 0)
    } else {
      fetchUserAndSetupNavBarTitle()
    }
  }
  
  func fetchUserAndSetupNavBarTitle() { // загружаем пользователя и сохраняем титул
    guard let uid = Auth.auth().currentUser?.uid else { // если currentUser 0 тогда выходим
      return
    }
    // получаем uid по из базы данных, берем значение
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
      
      // снепшот как словарь,если есть такой в масиве
      if (snapshot.value as? [String: AnyObject]) != nil {
        // имя ставим его на титул
        //self.navigationItem.title = dictionary["name"] as? String
        
        let user = User() // берем пользователя
      //  user.setValuesForKeys(dictionary)
        user.name = (snapshot.value as? NSDictionary)? ["name"] as? String
        user.profileImage = (snapshot.value as? NSDictionary)? ["profileImageUrl"] as? String
        print("setupNavBarWithUser")
        self.setupNavBarWithUser(user: user)// значение по ключу кладем в метод
      }
    }
  }
  
  func setupNavBarWithUser(user: User) { // нав бар с юзерм
    
    let titleViews = UIView()
    titleViews.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    titleViews.backgroundColor = UIColor.red
    self.navigationItem.titleView = titleViews

    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    titleViews.addSubview(containerView)
    containerView.centerXAnchor.constraint(equalTo: titleViews.centerXAnchor).isActive = true
    containerView.centerYAnchor.constraint(equalTo: titleViews.centerYAnchor).isActive = true
    
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.backgroundColor = UIColor.green
    profileImageView.layer.cornerRadius = 20
    profileImageView.clipsToBounds = true
    
    if let profileImageUrl = user.profileImage {
      profileImageView.loadImageUsingCachWithUrlString(urlString:profileImageUrl)
    }
    containerView.addSubview(profileImageView)
    profileImageView.leftAnchor.constraint(equalTo: titleViews.leftAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: titleViews.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    let nameLable = UILabel()
    nameLable.text = user.name
    nameLable.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(nameLable)
    
    nameLable.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    nameLable.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    nameLable.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    nameLable.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
  
    // касание на титул
   // titleViews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
  }
  
  
  @objc func showChatControllerForUser(_ user: User) { // показывать контроллре
    let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
    chatLogController.user = user
    navigationController?.pushViewController(chatLogController, animated: true)
  }
  
  
  @objc func handelLogout() { // выход
    do {
      try Auth.auth().signOut() // выполняем выход
    } catch let logoutError {
      print(logoutError)
    }
    let login  = LoginViewController() // переход на контроллер
    login.messagesController = self // указали какой имеено контроллер
    present(login, animated: true, completion: nil)
  }

}

