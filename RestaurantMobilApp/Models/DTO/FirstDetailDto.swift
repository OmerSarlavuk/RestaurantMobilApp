//
//  FirstDetailDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.06.2024.
//

import Foundation

struct FirstDetailDto{
    
    let categoryDescription: String
    let imageURL: String
    let categoryName: String
    
    init(categoryDescription: String, imageURL: String, categoryName: String) {
        self.categoryDescription = categoryDescription
        self.imageURL = imageURL
        self.categoryName = categoryName
    }
    
}

