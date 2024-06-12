//
//  FavoritesViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit


class FavoritesViewController: UIViewController {
    
    
    weak var coordinator: MainCoordinatorProtocol?
    
    
}


extension FavoritesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        self.navigationItem.title = "Favorites"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
}




