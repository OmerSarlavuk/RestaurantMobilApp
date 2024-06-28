//
//  LoginCoordinator.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 25.06.2024.
//

import UIKit


final class LoginCoordinator: Coordinator, LoginCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavBarColor()
    }
    
    func start() { }
    
    func navigateForgetPassword() {
        
        let vc = ForgetPasswordViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func navigateSignUp() {
     
        let vc = SignUpViewController()
        vc.coordinator = self
        rootViewController = vc
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
}

