//
//  LabelandGeneralViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 10.06.2024.
//

import UIKit
import SnapKit
import Then


class LabelandGeneralViewComponent: UIView {
    
    lazy private var content = UILabel().then{
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    struct ViewModel {
        
        let content: String
        let font: UIFont
        let textColor: UIColor
        let aligment: NSTextAlignment
        let borderWith: CGFloat
        let radius: CGFloat
        let borderColor: CGColor
        
        init(content: String, font: UIFont, textColor: UIColor, aligment: NSTextAlignment, borderWith: CGFloat, radius: CGFloat, borderColor: CGColor) {
            self.content = content
            self.font = font
            self.textColor = textColor
            self.aligment = aligment
            self.borderWith = borderWith
            self.radius = radius
            self.borderColor = borderColor
        }
        
    }
    
}

extension LabelandGeneralViewComponent {
    
    private func setupUI() {
        addSubview(content)
        setupConstraints()
    }
    
    private func setupConstraints() {
        content.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(8)
            $0.trailing.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(viewModel: ViewModel) {
        content.text = viewModel.content
        content.font = viewModel.font
        content.textColor = viewModel.textColor
        content.textAlignment = viewModel.aligment
        self.layer.borderWidth = viewModel.borderWith
        self.layer.cornerRadius = viewModel.radius
        self.layer.borderColor = viewModel.borderColor
    }
    
}

