//
//  LanguageSelectionsViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit
import SnapKit

class LanguageSelectionsViewComponent: UIView {
    
    
    lazy private var turkish: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("TR", for: .normal)
        button.setTitleColor(.iconandIdentifierViewComponentColor2, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy private var english: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("EN", for: .normal)
        button.setTitleColor(.iconandIdentifierViewComponentColor2, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .iconandIdentifierViewComponentColor2
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        turkish.isSelected = false
        english.isSelected = true
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

extension LanguageSelectionsViewComponent {
    
    private func setupUI() {
        self.backgroundColor = .tabbarLocationView
        self.layer.cornerRadius = 10
        addSubview(turkish)
        addSubview(english)
        setupConstraints()
    }
    
    private func setupConstraints() {
        turkish.snp.makeConstraints{
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        english.snp.makeConstraints{
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-5)
        }
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == turkish {
            turkish.isSelected = true
            english.isSelected = false
            english.backgroundColor = .white
            turkish.backgroundColor = .iconandIdentifierViewComponentColor2
        }
        if button == english {
            turkish.isSelected = false
            english.isSelected = true
            turkish.backgroundColor = .white
            english.backgroundColor = .iconandIdentifierViewComponentColor2
        }
        
    }
    
}


