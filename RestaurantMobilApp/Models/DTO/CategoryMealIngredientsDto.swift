//
//  CategoryMealIngredientsDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import Foundation

struct CategoryMealIngredientsDto {
    
    let strInstructions: String
    let youtubeURL: String
    
    init(strInstructions: String, youtubeURL: String) {
        self.strInstructions = strInstructions
        self.youtubeURL = youtubeURL
    }
    
}


