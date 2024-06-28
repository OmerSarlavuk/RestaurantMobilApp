//
//  EncyrptKEY.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//


import Foundation

enum EncyrptKEY {
    
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "Encyrpt-Key", ofType: "plist")
    else {
      fatalError("Couldn't find file 'Encyrpt-Key.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "Encyrpt_KEY") as? String else {
      fatalError("Couldn't find key 'Encyrpt_KEY' in 'Encyrpt-Key.plist'.")
    }
    if value.starts(with: "_") {
      fatalError(
        "Encyrpt Key not found, please check .plist file."
      )
    }
    return value
  }
    
}

