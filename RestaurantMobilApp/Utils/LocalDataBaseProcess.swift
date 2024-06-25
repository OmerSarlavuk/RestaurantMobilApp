//
//  LocalDataBaseProcess.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 12.06.2024.
//

import UIKit


public class LocalDataBaseProcess {
    
    let userDefault = UserDefaults.standard
    
    
    func setDATA(value: String, key: String) {
        
        userDefault.setValue(value, forKey: key)
        
    }
    
    func getDATA(key: String) -> String {
        
        let result = userDefault.string(forKey: key)
        
        if let res = result {
            return res
        }
        return ""
    }
    
    func removeDATA(key: String) {
        
        userDefault.removeObject(forKey: key)
        
    }
    
}


