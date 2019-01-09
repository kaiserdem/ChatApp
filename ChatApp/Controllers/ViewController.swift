//
//  ViewController.swift
//  ChatApp
//
//  Created by Kaiserdem on 09.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.handelLogin))

  }
  @objc func handelLogin() {
    let login  = LoginViewController()
    present(login, animated: true, completion: nil)
  }

}

