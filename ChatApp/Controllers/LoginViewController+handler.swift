//
//  LoginViewController+handler.swift
//  ChatApp
//
//  Created by Kaiserdem on 11.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func handleRegister() { // выполнит регистрацию
    guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else { // если пустые, принт, выходим
     // print("Error")
      return
    }
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error != nil { // если ошибка, принт, выходим
        return
      }
      
      guard let uid = user?.user.uid else { // создаем айди пользователя
        return
      }
      let imageName = NSUUID().uuidString // генерирует случайный айди
      // создали папку  для картинке в базе
      let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
   
  
      if let profileImageUrl = self.profileImageView.image, let  uploadData = profileImageUrl.jpegData(compressionQuality: 0.1) {
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
          
          if error != nil, metadata != nil {
            print(error ?? "")
            return
            
          }
          
          storageRef.downloadURL(completion: { (url, error) in
            if error != nil {
              print(error!.localizedDescription)
              return
            }
            if let profileImageUrl = url?.absoluteString {
              let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
              self.registeUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
            }
          })
        })
      }
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  private func registeUserIntoDatabaseWithUID(uid: String, values:[String: AnyObject]) {
    // ссылка на базу данных
    let ref = Database.database().reference()
    
    let userReference = ref.child("users").child(uid) // создали папку пользователя
    userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
      if error != nil {
        return
      }
    })

  }
    @objc func handleSelectProfileImageView() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true // можно менять размер
    present(picker, animated: true, completion: nil)
  }
  
  
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImageFromPicker: UIImage?
    if let editingImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editingImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      profileImageView.image = selectedImage
    }
    dismiss(animated: true, completion: nil) // выйти с контроллера

  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
