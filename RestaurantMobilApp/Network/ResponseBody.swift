//
//  ResponseBody.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 31.05.2024.
//

import UIKit


class ResponseBodyCategories: Codable {
    let categories: [Category]
}

class ResponseBodyMeals<T: Codable>: Codable {
    let meals: [T]
}


