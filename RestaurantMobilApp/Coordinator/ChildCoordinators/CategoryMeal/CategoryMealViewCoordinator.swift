//
//  CategoryMealViewCoordinator.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit


final class CategoryMealViewCoordinator: Coordinator, CategoryMealViewCoordinatorProtocol {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    func start() { }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavBarColor()
    }    
    
}

