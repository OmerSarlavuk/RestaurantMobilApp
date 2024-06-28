//
//  DataService.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 30.05.2024.
//

import UIKit
import Alamofire
import GoogleGenerativeAI

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
    
    
    func fetchCategoryNames(completion: @escaping (([CategoryName]) -> Void)) {
        
        AF.request("\(baseUrl)list.php?c=list", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(ResponseBodyMeals<CategoryName>.self, from: data)
                    completion(cevap.meals)
                    
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
    
    
    func fetchOpenAi(searchs: String, completion: @escaping ((String) -> Void)) {
        
        let model = GenerativeModel(name: "gemini-1.5-flash-latest", apiKey: APIKey.default)
        Task {
            do {
                let result = try await model.generateContent(searchs)
                
                guard let response = result.text else { return }
                
            } catch {
                debugPrint(error.localizedDescription)
            }
            
        }
        
    }
    
}


