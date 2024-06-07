//
//  DataService.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit
import Alamofire

class DataService: DataServiceProtocol {

    private let baseUrl: String = "https://www.themealdb.com/api/json/v1/1/"
    
    func fetchCategories(completion: @escaping (([Category]) -> Void)) {
        
        AF.request("\(baseUrl)categories.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(ResponseBodyCategories.self, from: data)
                    completion(cevap.categories)
                    
                } catch {
                    debugPrint(error.localizedDescription)
                }
            } else {
                print("!")
            }
            
        }
        
    }
    
    
    func fetchMeals(category: String, completion: @escaping (([Meal]) -> Void)) {
        
        AF.request("\(baseUrl)filter.php?c=\(category)", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(ResponseBodyMeals<Meal>.self, from: data)
                    completion(cevap.meals)
                    
                } catch {
                    debugPrint(error.localizedDescription)
                }
            } else {
                print("!")
            }
            
            
        }
        
    }
    
    func fetchMealDetail(idMeal: String, completion: @escaping (([MealDetail]) -> Void)) {
        
        AF.request("\(baseUrl)lookup.php?i=\(idMeal)", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(ResponseBodyMeals<MealDetail>.self, from: data)
                    completion(cevap.meals)
                    
                } catch {
                    debugPrint(error.localizedDescription)
                }
            } else {
                print("!")
            }
            
            
        }
        
    }
    
    
}


