//
//  PDFFileDto.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 28.06.2024.
//

import UIKit

//mealName, mealImage(direk image olarak alınacak), instructions(yapılışı) ve ingredients(malzemeler)

struct PDFFileDto {
    
    let mealName: String
    let mealImage: UIImage
    let instructions: String
    let ingredients: String
    
    init(mealName: String, mealImage: UIImage, instructions: String, ingredients: String) {
        self.mealName = mealName
        self.mealImage = mealImage
        self.instructions = instructions
        self.ingredients = ingredients
    }
    
}


