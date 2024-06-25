//
//  PhotosViewController.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit


class PhotosViewController: UIViewController {
    
    
    weak var coordinator: MainCoordinatorProtocol?
    
    
}


extension PhotosViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        self.navigationItem.title = "Photos"
    }
    
    private func setupUI() {
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
}


