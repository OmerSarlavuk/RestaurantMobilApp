//
//  DataServiceProtocol.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit


protocol DataServiceProtocol: AnyObject {
    
    func fetchCategories(completion: @escaping (([Category]) -> Void))
    func fetchCategoryNames(completion: @escaping (([CategoryName]) -> Void))
    func fetchMeals(category: String, completion: @escaping (([Meal]) -> Void))
    func fetchOpenAi(searchs: String, completion: @escaping ((String) -> Void))
    
}

