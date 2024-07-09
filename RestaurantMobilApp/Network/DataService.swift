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
    
    
    func fetchUserbyUserEmail(userEmail: String, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void)) {
        
        AF.request("http://10.19.10.194:8000/getUserbyuserEmail?userEmail=\(userEmail)", method: .get).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(ResponseBody<UserServiceModel>.self, from: data)
                    
                    
                    if let result = cevap.data {
                        completion(result, true, cevap.message)
                    } else {
                        completion(nil, false, cevap.message)
                    }
                    
                } catch {
                    completion(nil, false, error.localizedDescription)
                }
                
            } else {
                completion(nil, false, response.error?.localizedDescription)
            }
            
        }
        
    }
    
    func fetchVerifyEmail(userEmail: String, completion: @escaping ((String, Bool, String?) -> Void)) {
        
        AF.request("http://10.19.10.194:8000/verifyEmail?userEmail=\(userEmail)", method: .get).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(ResponseBody<String>.self, from: data)
                    
                    
                    if let result = cevap.data {
                        completion(result, true, cevap.message)
                    } else {
                        completion("", false, cevap.message)
                    }
                    
                } catch {
                    completion("", false, error.localizedDescription)
                }
                
            } else {
                completion("", false, response.error?.localizedDescription)
            }
            
        }
        
    }
    
    func updateUser(userPutDto: UserPutDto, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void)) {
        
        AF.request("http://10.19.10.194:8000/updateUser", method: .put, parameters: userPutDto, encoder: JSONParameterEncoder.default).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(ResponseBody<UserServiceModel>.self, from: data)
                    
                    if let result = cevap.data {
                        completion(result, true, cevap.message)
                    } else {
                        completion(nil, false, cevap.message)
                    }
                    
                } catch {
                    completion(nil, false, error.localizedDescription)
                }
                
            } else {
                completion(nil, false, response.error?.localizedDescription)
            }
            
        }
        
    }
    
    
    func signUpNewUser(userPostDto: UserPostDto, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void)) {
        
        AF.request("http://10.19.10.194:8000/users", method: .post, parameters: userPostDto, encoder: JSONParameterEncoder.default).response { response in
            
            if let data = response.data {
                
                do {
                    let cevap = try JSONDecoder().decode(ResponseBody<UserServiceModel>.self, from: data)
                    
                    if let result = cevap.data {
                        completion(result, true, cevap.message)
                    } else {
                        completion(nil, false, cevap.message)
                    }
                    
                } catch {
                    completion(nil, false, error.localizedDescription)
                }
                
            } else {
                completion(nil, false, response.error?.localizedDescription)
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
                
                guard let _ = result.text else { return }
                
            } catch {
                debugPrint(error.localizedDescription)
            }
            
        }
        
    }
    
}


