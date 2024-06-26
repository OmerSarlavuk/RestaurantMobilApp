//
//  SignUpViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 25.06.2024.
//

import UIKit
import SnapKit


class SignUpViewController: UIViewController {
    
    weak var coordinator: LoginCoordinatorProtocol?
    
    
    
    
}

extension SignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "Sign Up"
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
}


