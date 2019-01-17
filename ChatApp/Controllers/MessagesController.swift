//
//  MessagesController.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase //not

class MessagesController: UITableViewController {

  let cellId = "cellId"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handelLogout))
    
    let image = UIImage(named: "edit")
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handelNewMessage))
    
    checkIfUserIsLogedIn() // проверить, если пользователь вошел в систему

                                     // регистрируем ячейку
    tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    
    observeUserMessages()
  }
  
  var messages = [Message]()
  var messagesDictionary = [String: Message]() // масив для групировки сообщений
  
  func observeUserMessages() { // наблюдатель
    guard let uid = Auth.auth().currentUser?.uid else { return } // айди на пользователя
                // ссылка на все сообщения пользователя
    let ref = Database.database().reference().child("user-messages").child(uid)
    ref.observe(.childAdded, with: { (snapshot) in
 //     print(snapshot)
      
      let messageId = snapshot.key // ключ сообщения
      let messageReference = Database.database().reference().child("messages").child(messageId) // сслка на сообщения по id
      
      messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
 //       print(snapshot)
        
        if let dictionary = snapshot.value as? [String: AnyObject] { // словарь из всего
          let message = Message(dictionary: dictionary) // данные в масив
          
          if let toId = message.toId { // если есть Id получателья
            self.messagesDictionary[toId] = message // по toId было отправлено это message сообщение
            
            self.messages = Array(self.messagesDictionary.values)
            self.messages.sort(by: { (message1, message2) -> Bool in // сортировать
              // дата первого сообщения больше чем второго
              return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
            })
          }
          DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
          })
        }
        
      }, withCancel: nil)
      
    }, withCancel: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count // кол сообщений
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
    
    let message = messages[indexPath.row]
    
    cell.message = message
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 72
  }
                              // когда выбрали ячейку
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let message = self.messages[indexPath.row] // сообщение которое в эжтой ячейке
    
    guard let chatPartnerId = message.chatPartnerId() else { return } // айди получателя
                                // получили пользователя получателя по Id
    let ref = Database.database().reference().child("users").child(chatPartnerId)
                         // из ссылки берем значение
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                 // снепшот в словарь по значению
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(dictionary: dictionary) // создаем пользователя
      user.id = chatPartnerId // id получаетля
      self.showChatControllerForUser(user) // показать чат контроллер для пользователя

      
    }, withCancel: nil)
  }
  
  @objc func handelNewMessage() {
    let newMessageController = NewMessageController()
    newMessageController.messagesController = self // какой именно контролллер
    let navController = UINavigationController(rootViewController: newMessageController)
    present(navController, animated: true, completion: nil)
  }
  
  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему

    if Auth.auth().currentUser?.uid == nil { // если мы не вошли
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
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if let dictionary = snapshot.value as? [String: AnyObject] {
        
        let user = User(dictionary: dictionary)
        self.setupNavBarWithUser(user)
      }
    }, withCancel: nil)
  }
  
  func setupNavBarWithUser(_ user: User) { //звгрузить нав бар с юзерм
    
    messages.removeAll() // все сообщения из масива удалить
    messagesDictionary.removeAll() // удалить и библиотеки
    tableView.reloadData()   // обновить сообщения
    
    observeUserMessages()
    
    let titleViews = UIView()
    titleViews.frame = CGRect(x: 0, y: 0, width: 100, height: 40)

    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    titleViews.addSubview(containerView)
    
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.backgroundColor = UIColor.green
    profileImageView.layer.cornerRadius = 20
    profileImageView.clipsToBounds = true
    
    if let profileImageUrl = user.profileImageUrl {
      profileImageView.loadImageUsingCachWithUrlString(profileImageUrl)
    }
    containerView.addSubview(profileImageView)

    profileImageView.leftAnchor.constraint(equalTo: titleViews.leftAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: titleViews.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    titleViews.backgroundColor = UIColor.clear
    
    let nameLable = UILabel()
    
    containerView.addSubview(nameLable)
    nameLable.text = user.name
    nameLable.translatesAutoresizingMaskIntoConstraints = false
    nameLable.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    nameLable.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    nameLable.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    nameLable.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
    
    containerView.centerXAnchor.constraint(equalTo: titleViews.centerXAnchor).isActive = true
    containerView.centerYAnchor.constraint(equalTo: titleViews.centerYAnchor).isActive = true
    
    self.navigationItem.titleView = titleViews

  }
  
  @objc func showChatControllerForUser(_ user: User) { // показать чат контроллер для пользователя

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
    
    let loginController  = LoginController() // переход на контроллер
    loginController.messagesController = self // указали какой имеено контроллер
    present(loginController, animated: true, completion: nil)
  }

}

