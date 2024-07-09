//
//  MenuViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 31.05.2024.
//

import UIKit
import SnapKit


class menuItemViewComponent: UIView {
    
    
    lazy private var icon: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy private var title: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    struct ViewModel {
        
        let icon: UIImage
        let title: String
        let font: UIFont
        let textColor: UIColor
        let handleTap: VoidCallback
        
        init(icon: UIImage, title: String, font: UIFont, textColor: UIColor, handleTap: @escaping VoidCallback) {
            self.icon = icon
            self.title = title
            self.font = font
            self.textColor = textColor
            self.handleTap = handleTap
        }
        
    }
    
}

extension menuItemViewComponent {
    
    private func setupUI() {
        addSubview(icon)
        addSubview(title)
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        icon.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        title.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
        }
        
    }
    
    func configure(viewModel: ViewModel) {
        icon.image = viewModel.icon
        title.text = viewModel.title
        title.font = viewModel.font
        title.textColor = viewModel.textColor
        self.onTap(handler: viewModel.handleTap)
    }
    
}


