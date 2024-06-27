//
//  paymentOptionsViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 27.06.2024.
//

import UIKit
import SnapKit

class paymentOptionsViewComponent: UIView {
    
    lazy private var time = UILabel()
    lazy private var price = UILabel()
    lazy private var discount = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    struct ViewModel {
        
        let time: String
        let fontS: UIFont
        let textColorS: UIColor
        let price: String
        let fontP: UIFont
        let textColorP: UIColor
        let discount: String
        let fontD: UIFont
        let textColorD: UIColor
        let componentRadius: CGFloat
        let componentBackgroundColor: UIColor
        
        init(time: String, fontS: UIFont, textColorS: UIColor, price: String, fontP: UIFont, textColorP: UIColor, discount: String, fontD: UIFont, textColorD: UIColor, componentRadius: CGFloat, componentBackgroundColor: UIColor) {
            self.time = time
            self.fontS = fontS
            self.textColorS = textColorS
            self.price = price
            self.fontP = fontP
            self.textColorP = textColorP
            self.discount = discount
            self.fontD = fontD
            self.textColorD = textColorD
            self.componentRadius = componentRadius
            self.componentBackgroundColor = componentBackgroundColor
        }
        
    }
    
}

extension paymentOptionsViewComponent {
    
    private func setupUI() {
        addSubview(time)
        addSubview(discount)
        addSubview(price)
        setupConstraints()
    }
    
    private func setupConstraints() {
        time.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview().offset(-20)
        }
        discount.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview().offset(20)
        }
        price.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(viewModel: ViewModel) {
        
        time.text = viewModel.time
        time.font = viewModel.fontS
        time.textColor = viewModel.textColorS
        
        price.text = viewModel.price
        price.font = viewModel.fontP
        price.textColor = viewModel.textColorP
        
        discount.text = viewModel.discount
        discount.font = viewModel.fontD
        discount.textColor = viewModel.textColorD
        
        self.layer.cornerRadius = viewModel.componentRadius
        self.backgroundColor = viewModel.componentBackgroundColor
        
    }
    
}


