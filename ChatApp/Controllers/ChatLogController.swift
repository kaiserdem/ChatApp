//
//  ChatLogController.swift
//  ChatApp
//
//  Created by Kaiserdem on 15.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
  
  lazy var inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter message..."
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self // подписали делегат
    return textField
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupInputComponents()
    
    navigationItem.title = "Chat Log Controller"
  }
  func setupInputComponents() { // компоненты контроллера
    let conteinerView = UIView()
    conteinerView.backgroundColor = UIColor.red
    conteinerView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(conteinerView)
    
    conteinerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    conteinerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    conteinerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    conteinerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Send", for: .normal)
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    conteinerView.addSubview(sendButton)
    
    sendButton.rightAnchor.constraint(equalTo: conteinerView.rightAnchor).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    sendButton.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
                     // при нажатии
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    conteinerView.addSubview(inputTextField)
    
    inputTextField.leftAnchor.constraint(equalTo: conteinerView.leftAnchor, constant: 8).isActive = true
    inputTextField.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
    inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    inputTextField.heightAnchor.constraint(equalTo: conteinerView.heightAnchor).isActive = true
    
    let separatorLineView = UIView()
    separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    separatorLineView.translatesAutoresizingMaskIntoConstraints = false
    conteinerView.addSubview(separatorLineView)
    
    separatorLineView.leftAnchor.constraint(equalTo: conteinerView.leftAnchor).isActive = true
    separatorLineView.topAnchor.constraint(equalTo: conteinerView.topAnchor).isActive = true
    separatorLineView.widthAnchor.constraint(equalTo: conteinerView.widthAnchor).isActive = true
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
  }
  @objc func handleSend() {
    let ref = Database.database().reference().child("messages") // новая ветка
    let childRef = ref.childByAutoId() // вернет всех детей
    let values = ["text": inputTextField.text, "name": "Hello world"] as [String : Any]
    childRef.updateChildValues(values)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     handleSend()
    return true
  }
}
