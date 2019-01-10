//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  let inputContainerView: UIView = { // создаем вю
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.translatesAutoresizingMaskIntoConstraints = false // для указания констрейнтов
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    return view
  }()
  
  let registerButtonView: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("Register", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.backgroundColor = UIColor(r: 83, g: 155, b: 97)
    btn.layer.cornerRadius = 5
    btn.layer.masksToBounds = true

    return btn
  }()
  
  let nameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Name"
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true // теекст скрыт
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()
  
  let nameFieldSeparator: UIView = {
    let sp = UIView()
    sp.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    sp.translatesAutoresizingMaskIntoConstraints = false
    return sp
  }()
  
  let emailFieldSeparator: UIView = {
    let sp = UIView()
    sp.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    sp.translatesAutoresizingMaskIntoConstraints = false
    return sp
  }()
  
  let profileImageView: UIImageView = {
    let pf = UIImageView()
    pf.image = UIImage(named: "language")
    pf.contentMode = .scaleAspectFill
    pf.translatesAutoresizingMaskIntoConstraints = false
    return pf
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.view.addSubview(inputContainerView)
      self.view.addSubview(registerButtonView)
      self.view.addSubview(profileImageView)
      
      setupInputsContainerViewConstraints()
      setupRegisterButtonViewConstraints()
      setupProfileImageViewConstraints()
      
      self.view.backgroundColor = UIColor(r: 25, g: 129, b: 46)
    }
  func setupInputsContainerViewConstraints() {
    inputContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
    inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    inputContainerView.addSubview(nameTextField)
    inputContainerView.addSubview(emailTextField)
    inputContainerView.addSubview(passwordTextField)
    
    inputContainerView.addSubview(nameFieldSeparator)
    inputContainerView.addSubview(emailFieldSeparator)

    nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
    nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
    emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
    passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
    
    nameFieldSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
    nameFieldSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
    nameFieldSeparator.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
    nameFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    emailFieldSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
    emailFieldSeparator.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
    emailFieldSeparator.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
    emailFieldSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  func setupProfileImageViewConstraints() {
    profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }
  
  func setupRegisterButtonViewConstraints() {
    registerButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    registerButtonView.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 8).isActive = true
    registerButtonView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    registerButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent //светлые значк статус бара
  }

}
