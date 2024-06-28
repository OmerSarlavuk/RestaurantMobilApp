//
//  MealViewModel.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 3.06.2024.
//

import UIKit


class MealViewModel {
    
    
    private let dataService: DataService?
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    
    func fetchMeals(category: String, completion: @escaping (([Meal]) -> Void)) {
        dataService?.fetchMeals(category: category, completion: { meals in
            completion(meals)
        })
    }
    
    
}

