//
//  UserPutDto.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 9.07.2024.
//

import Foundation


struct UserPutDto: Codable {
    
    let userId: Int
    let userFullName: String?
    let userEmail: String?
    let userPhoto: String?
    let isActive: Bool?
    let userPassword: String?
    
    init(userId: Int, userFullName: String?, userEmail: String?, userPhoto: String?, isActive: Bool?, userPassword: String?) {
        self.userId = userId
        self.userFullName = userFullName
        self.userEmail = userEmail
        self.userPhoto = userPhoto
        self.isActive = isActive
        self.userPassword = userPassword
    }
    
}

