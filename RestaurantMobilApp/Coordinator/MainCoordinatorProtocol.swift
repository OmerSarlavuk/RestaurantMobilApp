//
//  MainCoordinatorProtocol.swift
//  DenemeProje
//
//  Created by Ahlatci on 21.05.2024.
//

import Foundation

protocol MainCoordinatorProtocol : AnyObject {
    
    func navigateFirstDetail(firstDetailDto: FirstDetailDto)
    func navigateCategoryMeal(categoryMealDto: CategoryMealDto)
    
}

