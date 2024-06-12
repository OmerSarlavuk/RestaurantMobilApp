//
//  FirstViewCoordinatorProtocol.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 4.06.2024.
//

import Foundation

protocol FirstDetailViewCoordinatorProtocol: AnyObject {
    
    func navigateCategoryMeal(categoryMealDto: CategoryMealDto)
    func navigateCategoryMealIngredients(categoryMealIngredientsDto: CategoryMealIngredientsDto)
    
}
