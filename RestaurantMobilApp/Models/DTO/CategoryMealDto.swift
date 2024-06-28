//
//  CategoryMealDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 5.06.2024.
//

import Foundation


struct CategoryMealDto {
    
    let mealName: String
    let mealId: String
    let mealURL: String
    
    init(mealName: String, mealId: String, mealURL: String) {
        self.mealName = mealName
        self.mealId = mealId
        self.mealURL = mealURL
    }
    
}

