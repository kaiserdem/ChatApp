//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class LoginViewController: UIViewController {

  let inputContainerView: UIView = { // созд@objc @objc аем вю
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.translatesAutoresizingMaskIntoConstraints = false // для указания констрейнтов
    view.layer.cornerRadius = 5
    view.layer.masksToBounds = true
    return view
  }()
  
  lazy var loginRegisterButtonView: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("Register", for: .normal)
    btn.setTitleColor(UIColor.white, for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.backgroundColor = UIColor(r: 83, g: 155, b: 97)
    btn.layer.cornerRadius = 5
    btn.layer.masksToBounds = true

    btn.addTarget(self, action: #selector(LoginViewController.handleLoginRegister), for: .touchUpInside)
    return btn
  }()
  
  @objc func handleLoginRegister() { // вызов функции по индексу
    if loginRegisterSegmentedControll.selectedSegmentIndex == 0 {
      handleLogin()
    } else {
      handleRegister()
    }
  }
    func handleLogin() {
      guard let email = emailTextField.text, let password = passwordTextField.text else {
        print("Form is not valid")
        return
      }
      Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        if error != nil {
          return
        }
        self.dismiss(animated: true, completion: nil)
      }
    }
    

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
    tf.isSecureTextEntry = true // теекст скры@objc @objc т
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
  
  lazy var profileImageView: UIImageView = {
    let pf = UIImageView()
    pf.image = UIImage(named: "language")
    pf.contentMode = .scaleAspectFill
    pf.translatesAutoresizingMaskIntoConstraints = false
    
    pf.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleSelectProfileImageView)))
    pf.isUserInteractionEnabled = true
    return pf
  }()
  
  
  lazy var loginRegisterSegmentedControll: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Login", "Register"])
    sc.translatesAutoresizingMaskIntoConstraints = false
    sc.tintColor = UIColor.white
    sc.selectedSegmentIndex = 1
    let font = UIFont.systemFont(ofSize: 18)
    sc.setTitleTextAttributes([NSAttributedString.Key.font: font],
                                            for: .normal)
    sc.addTarget(self, action: #selector(LoginViewController.handleLoginRegisterChange), for: .valueChanged)
    return sc
  }()
  
  @objc func handleLoginRegisterChange() {
    // меняем титул по индексу
    let titel = loginRegisterSegmentedControll.titleForSegment(at: loginRegisterSegmentedControll.selectedSegmentIndex)
    
    loginRegisterButtonView.setTitle(titel, for: .normal) // по дефолту
    
    inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 100 : 150 // если индекст 0 тогда высота 100, в противном случае 150
    
    nameTextFieldHeightAnchor?.isActive = false // сначала констрейнт выключаем
    nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 0 : 1/3)
    // если индекс 0 тогда высота 0(так как она убираеться), в противном случае как и было 1/3
    nameTextFieldHeightAnchor?.isActive = true // включаем констрейнт
    
    emailTextFieldHeightAnchor?.isActive = false
    emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 1/2 : 1/3)
    emailTextFieldHeightAnchor?.isActive = true
    
    passwordTextFieldHeightAnchor?.isActive = false
    passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControll.selectedSegmentIndex == 0 ? 1/2 : 1/3)
    passwordTextFieldHeightAnchor?.isActive = true
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.view.addSubview(inputContainerView)
      self.view.addSubview(loginRegisterButtonView)
      self.view.addSubview(profileImageView)
      self.view.addSubview(loginRegisterSegmentedControll)
      
      setupInputsContainerViewConstraints()
      setupRegisterButtonViewConstraints()
      setupProfileImageViewConstraints()
      setupLoginSegmentedControl()
      
      self.view.backgroundColor = UIColor(r: 25, g: 129, b: 46)
      
      
    }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  var inputsContainerViewHeightAnchor:NSLayoutConstraint?
  var nameTextFieldHeightAnchor:NSLayoutConstraint?
  var emailTextFieldHeightAnchor:NSLayoutConstraint?
  var passwordTextFieldHeightAnchor:NSLayoutConstraint?

  func setupLoginSegmentedControl() {
    loginRegisterSegmentedControll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loginRegisterSegmentedControll.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
    loginRegisterSegmentedControll.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
    loginRegisterSegmentedControll.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }
  
  func setupInputsContainerViewConstraints() {
    inputContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    inputContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    inputContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
    inputsContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
    inputsContainerViewHeightAnchor?.isActive = true
    
    inputContainerView.addSubview(nameTextField)
    inputContainerView.addSubview(emailTextField)
    inputContainerView.addSubview(passwordTextField)
    
    inputContainerView.addSubview(nameFieldSeparator)
    inputContainerView.addSubview(emailFieldSeparator)

    nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
    nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3) // высота треть белого поля
    nameTextFieldHeightAnchor?.isActive = true
    
    emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
    emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
      emailTextFieldHeightAnchor?.isActive = true
    
    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
    passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
    passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
    passwordTextFieldHeightAnchor?.isActive = true
    
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
    profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControll.topAnchor, constant: -12).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }
  
  func setupRegisterButtonViewConstraints() {
    loginRegisterButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    loginRegisterButtonView.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
    loginRegisterButtonView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    loginRegisterButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent //светлые значк статус бара
  }

}
