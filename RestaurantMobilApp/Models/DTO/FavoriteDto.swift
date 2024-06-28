//
//  FavoriteDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 12.06.2024.
//

import Foundation


struct FavoriteDto {
    
    let mealId: String
    let imageURL: String
    let mealName: String
    
    init(mealId: String, imageURL: String, mealName: String) {
        self.mealId = mealId
        self.imageURL = imageURL
        self.mealName = mealName
    }
    
}

