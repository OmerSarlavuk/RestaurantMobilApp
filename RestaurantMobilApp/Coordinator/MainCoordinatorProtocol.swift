//
//  MainCoordinatorProtocol.swift
//  DenemeProje
//
//  Created by Ahlatci on 21.05.2024.
//

import Foundation

protocol MainCoordinatorProtocol : AnyObject {
    
    func navigateFirstDetail(firstDetailDto: FirstDetailDto)
    func navigateAi()
    func navigateReservation()
    func navigateLocation()
    func navigatePhotos()
    func navigateFavorite()
    func navigateAbout()
    func navigateLogin()
    func navigateCategoryMeal(categoryMealDto: CategoryMealDto)
    func navigateCategoryMealIngredients(categoryMealIngredientsDto: CategoryMealIngredientsDto)
    func navigateForgetPassword()
    func navigateSignUp()
    func navigateBasket()
    func navigateBasketSubscription()
    
}

