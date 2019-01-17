//
//  Extension.swift
//  ChatApp
//
//  Created by Kaiserdem on 13.01.2019.
//  Copyright © 2019 Kaiserdem. All rights reserved.
//
import Foundation
import UIKit

let imageCach = NSCache<AnyObject, AnyObject>()

extension UIImageView {
               // загрузка картинки с кеша
  func loadImageUsingCachWithUrlString( _ urlString: String) {
    self.image = nil // по дефолту
               // если есть такая картинка тогда загружаем из кеша
    if let cachedImage = imageCach.object(forKey: urlString as AnyObject) as? UIImage {
      self.image = cachedImage
      return
    }
             // в противном случае берем из интернета
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil{
        print(error ?? "")
        return
      }
      DispatchQueue.main.async(execute: {
        if let downloadedImage = UIImage(data: data!) { // загруженое изображение
          imageCach.setObject(downloadedImage, forKey: urlString as AnyObject)
          
          self.image = downloadedImage
        }
      })
    }
  }
}
/*
extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: 255, green: 255, blue: 255, alpha: 1)
  }
}
*/
