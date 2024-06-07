//
//  MealDetailViewModel.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 5.06.2024.
//

import UIKit


class MealDetailViewModel {
    
    private let dataService: DataService?
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    public struct MealDetailClearModel {
        
        let strInstructions: String
        let strIngredients: [String]
        let strYoutube: String
        let strSource: String
        
        init(strInstructions: String, strIngredients: [String], strYoutube: String, strSource: String) {
            self.strInstructions = strInstructions
            self.strIngredients = strIngredients
            self.strYoutube = strYoutube
            self.strSource = strSource
        }
        
    }
    
    
    func fetchMealDetail(idMeal: String, completion: @escaping ((MealDetailClearModel) -> Void)) {
        dataService?.fetchMealDetail(idMeal: idMeal, completion: { md in
            let mealDetail = md[0]
            var ingredient: [String] = []
            let ingredients: [String] = [mealDetail.strIngredient1, mealDetail.strIngredient2, mealDetail.strIngredient3, mealDetail.strIngredient4, mealDetail.strIngredient5, mealDetail.strIngredient6, mealDetail.strIngredient7, mealDetail.strIngredient8, mealDetail.strIngredient9, mealDetail.strIngredient10, mealDetail.strIngredient11, mealDetail.strIngredient12, mealDetail.strIngredient13, mealDetail.strIngredient13, mealDetail.strIngredient14, mealDetail.strIngredient15, mealDetail.strIngredient16, mealDetail.strIngredient17, mealDetail.strIngredient18, mealDetail.strIngredient19, mealDetail.strIngredient20]
            var index = 0
            ingredients.forEach{
                if !$0.isEmpty {
                    index += 1
                    ingredient.append($0)
                }
            }
            
            
            let measures: [String] = [mealDetail.strMeasure1, mealDetail.strMeasure2, mealDetail.strMeasure3, mealDetail.strMeasure4, mealDetail.strMeasure5, mealDetail.strMeasure6, mealDetail.strMeasure7, mealDetail.strMeasure8, mealDetail.strMeasure9, mealDetail.strMeasure10, mealDetail.strMeasure11, mealDetail.strMeasure12, mealDetail.strMeasure13, mealDetail.strMeasure13, mealDetail.strMeasure14, mealDetail.strMeasure15, mealDetail.strMeasure16, mealDetail.strMeasure17, mealDetail.strMeasure18, mealDetail.strMeasure19, mealDetail.strMeasure20]
            var measure: [String] = []
            
            for number in 1...index {
                measure.append(measures[number-1])
            }
                    
            
            var total: [String] = []
            
            for number in 1...ingredient.count {
                total.append("\(measure[number - 1]) \(ingredient[number - 1])")
            }
            
            total.removeLast(2)
            
            let mealDetailClearModel = MealDetailClearModel(
                strInstructions: mealDetail.strInstructions,
                strIngredients: total,
                strYoutube: mealDetail.strYoutube,
                strSource: mealDetail.strSource)
            
            completion(mealDetailClearModel)
            
        })
    }
    
}

