//
//  DataServiceProtocol.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit


protocol DataServiceProtocol: AnyObject {
    
    func fetchCategories(completion: @escaping (([Category]) -> Void))
    func fetchMeals(category: String, completion: @escaping (([Meal]) -> Void)) 
    
}

