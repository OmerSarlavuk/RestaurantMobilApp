//
//  User.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 3.07.2024.
//

import Foundation

struct UserServiceModel: Codable{
    let IsActive: Bool
    let UserId: Int
    let UserFullName: String
    let UserPhoto: String?
    let UserPassword: String
    let UserEmail: String
}

