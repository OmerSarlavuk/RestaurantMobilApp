//
//  LocationViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit


class LocationViewController: UIViewController {
    
    
    weak var coordinator: MainCoordinatorProtocol?
    
    
}


extension LocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        self.navigationItem.title = "Location"
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


