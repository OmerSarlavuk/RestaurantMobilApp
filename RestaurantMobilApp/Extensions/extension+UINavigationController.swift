//
//  extension+UINavigationController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 4.06.2024.
//

import UIKit
import SnapKit


extension UINavigationController {
    
    
    func setNavBarColor() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .tabbarLocationView
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        
        self.navigationBar.tintColor = .white
        UIBarButtonItem.appearance().tintColor = .white
        
    }
    
    
}


