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
    
  }
  
  @objc func handelNewMessage() {
    let newMessageController = NewMessageController()
    let navController = UINavigationController(rootViewController: newMessageController)
    present(navController, animated: true, completion: nil)
  }
  
  func checkIfUserIsLogedIn() { // проверка если пользователь вошел в систему

    if Auth.auth().currentUser == nil { // если мы не вошли
      perform(#selector(handelLogout), with: nil, afterDelay: 0)
    } else {
      let uid = Auth.auth().currentUser?.uid // если мы в системе
                                  // получаем uid по из базы данных, берем значение
      Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in // снепшот как словарь,если есть такой в масиве
       // print(snapshot)
        if let dictionary = snapshot.value as? [String: AnyObject] {
          // берем имя ставим его на титул
          self.navigationItem.title = dictionary["name"] as? String
        }
      }
    }
  }
  @objc func handelLogout() { // выход
    do {
      try Auth.auth().signOut() // выполняем выход
    } catch let logoutError {
      print(logoutError)
    }
    let login  = LoginViewController() // переход на контроллер
    present(login, animated: true, completion: nil)
  }

}

