//
//  MainCoordinator.swift
//  DenemeProje
//
//  Created by Ahlatci on 21.05.2024.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, MainCoordinatorProtocol {
  
    var window: UIWindow
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    init(_ window: UIWindow) {
        self.navigationController = UINavigationController()
        self.window = window
        super.init()
        self.navigationController.delegate = self
        self.navigationController.setNavBarColor()
        self.window.rootViewController = self.navigationController
    }
    
    
    func start() {
        let vc = FirstViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
        window.makeKeyAndVisible()
    }
    
    func navigateAi() {
        let vc = AiViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateFirstDetail(firstDetailDto: FirstDetailDto) {
        let vc = FirstDetailViewController()
        vc.coordinator = self
        vc.firstDetailDto = firstDetailDto
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateReservation() {
        let vc = ResevervationViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateLocation() {
        let vc = LocationViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigatePhotos() {
        let vc = PhotosViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateFavorite() {
        let vc = FavoritesViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateAbout() {
        let vc = AboutViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateCategoryMeal(categoryMealDto: CategoryMealDto) {
        let coordinator = FirstDetailViewCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.navigateCategoryMeal(categoryMealDto: categoryMealDto)
    }

    func navigateCategoryMealIngredients(categoryMealIngredientsDto: CategoryMealIngredientsDto) {
        let coordinator = FirstDetailViewCoordinator(navigationController: navigationController)
        self.childCoordinators.append(coordinator)
        coordinator.navigateCategoryMealIngredients(categoryMealIngredientsDto: categoryMealIngredientsDto)
    }
    
}

// MARK: - UINavigationControllerDelegate
extension MainCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        
        
        checkIfChildFinish(fromViewController)
    }

}

