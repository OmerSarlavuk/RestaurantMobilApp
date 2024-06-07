//
//  CategoryViewModel.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit


class CategoryViewModel {
    
    private let dataService: DataService?
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    
    func fetchCategories(completion: @escaping (([Category]) -> Void)) {
        dataService?.fetchCategories(completion: { categories in
            completion(categories)
        })
    }
    
}

