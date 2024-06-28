//
//  FirstViewCoordinator.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.06.2024.
//

import UIKit


final class FirstDetailViewCoordinator: Coordinator, FirstDetailViewCoordinatorProtocol {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavBarColor()
    }
    
    func start() { }
    
    func navigateCategoryMeal(categoryMealDto: CategoryMealDto) {
        let vc = CategoryMealViewController()
        vc.coordinator = self
        vc.categoryMealDto = categoryMealDto
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func navigateCategoryMealIngredients(categoryMealIngredientsDto: CategoryMealIngredientsDto) {
        
        let vc = CategoryMealIngredientsViewController()
        vc.coordinator = self
        vc.mealIngredientsDto = categoryMealIngredientsDto
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func navigatePDF(dto: PDFFileDto) {
        
        let vc = PDFViewController()
        vc.coordinator = self
        vc.dto = dto
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
        
    }
    
}

