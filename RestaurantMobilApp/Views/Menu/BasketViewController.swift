//
//  BasketViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 26.06.2024.
//

import UIKit
import SnapKit


class BasketViewController: UIViewController {
    
    weak var coordinator: MainCoordinatorProtocol?
    
    
}

extension BasketViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        self.navigationItem.title = "My Basket"
    }
    
    private func setupUI() {
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
    
}


