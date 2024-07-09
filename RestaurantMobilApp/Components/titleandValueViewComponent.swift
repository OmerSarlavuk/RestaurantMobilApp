//
//  TitleandValueViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import UIKit
import SnapKit


class titleandValueViewComponent: UIView {
    
    
    lazy private var title: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy private var value: UILabel = {
       let label = UILabel()
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
        
        let title: String
        let titleFont: UIFont
        let titleTextColor: UIColor
        let titleTextAligment: NSTextAlignment
        let value: String
        let valueFont: UIFont
        let valueTextColor: UIColor
        let valueTextAligment: NSTextAlignment
        
        init(title: String, titleFont: UIFont, titleTextColor: UIColor, titleTextAligment: NSTextAlignment, value: String, valueFont: UIFont, valueTextColor: UIColor, valueTextAligment: NSTextAlignment) {
            self.title = title
            self.titleFont = titleFont
            self.titleTextColor = titleTextColor
            self.titleTextAligment = titleTextAligment
            self.value = value
            self.valueFont = valueFont
            self.valueTextColor = valueTextColor
            self.valueTextAligment = valueTextAligment
        }
        
    }
    
}

extension titleandValueViewComponent {
    
    
    private func setupUI() {
        addSubview(title)
        addSubview(value)
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
        value.snp.makeConstraints{
            $0.leading.equalTo(title.snp.leading)
            $0.top.equalTo(title.snp.bottom).offset(10)
        }
    }
    
    func configure(viewModel: ViewModel) {
        title.text = viewModel.title
        title.font = viewModel.titleFont
        title.textColor = viewModel.titleTextColor
        title.textAlignment = viewModel.titleTextAligment
        value.text = viewModel.value
        value.font = viewModel.valueFont
        value.textColor = viewModel.valueTextColor
        value.textAlignment = viewModel.valueTextAligment
    }
    
    
}


