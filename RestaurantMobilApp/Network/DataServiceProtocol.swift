//
//  DataServiceProtocol.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 30.05.2024.
//

import UIKit


protocol DataServiceProtocol: AnyObject {
    
    func fetchCategories(completion: @escaping (([Category]) -> Void))
    func fetchCategoryNames(completion: @escaping (([CategoryName]) -> Void))
    func fetchMeals(category: String, completion: @escaping (([Meal]) -> Void))
    func fetchOpenAi(searchs: String, completion: @escaping ((String) -> Void))
    func fetchUserbyUserEmail(userEmail: String, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void))
    func signUpNewUser(userPostDto: UserPostDto, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void))
    func fetchVerifyEmail(userEmail: String, completion: @escaping ((String, Bool, String?) -> Void))
    func updateUser(userPutDto: UserPutDto, completion: @escaping ((UserServiceModel?, Bool, String?) -> Void))
    
}

