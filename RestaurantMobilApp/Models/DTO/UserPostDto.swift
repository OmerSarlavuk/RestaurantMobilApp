//
//  UserPostDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.07.2024.
//

import Foundation


struct UserPostDto: Codable {
    
    let userFullName: String
    let userEmail: String
    let userPhoto: String?
    let isActive: Bool
    let userPassword: String?
    
    init(userFullName: String, userEmail: String, userPhoto: String?, isActive: Bool, userPassword: String?) {
        self.userFullName = userFullName
        self.userEmail = userEmail
        self.userPhoto = userPhoto
        self.isActive = isActive
        self.userPassword = userPassword
    }
    
}

