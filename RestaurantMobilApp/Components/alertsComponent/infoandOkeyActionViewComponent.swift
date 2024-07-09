//
//  infoandOkeyActionViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 8.07.2024.
//

import UIKit
import SnapKit
import Then


class infoandOkeyActionViewComponent: UIView {
    
    var action: ((Bool) -> Void)?
    
    lazy private var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy private var info = UILabel().then{$0.numberOfLines = 0}
    
    lazy private var line = UIView().then{ $0.backgroundColor = .clearLightGray }
    
    lazy private var okey: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    struct ViewModel {
        
        let image: UIImage
        let info: String
        let textAligment: NSTextAlignment
        let textColor: UIColor
        let font: UIFont
        let buttonTitle: String
        let buttonTitleColor: UIColor
        let cornerRadius: CGFloat
        let backgroundColor: UIColor
        let action: ((Bool) -> Void)?
        
        init(image: UIImage, info: String, textAligment: NSTextAlignment, textColor: UIColor, font: UIFont, buttonTitle: String, buttonTitleColor: UIColor, cornerRadius: CGFloat, backgroundColor: UIColor, action: ((Bool) -> Void)?) {
            self.image = image
            self.info = info
            self.textAligment = textAligment
            self.textColor = textColor
            self.font = font
            self.buttonTitle = buttonTitle
            self.buttonTitleColor = buttonTitleColor
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.action = action
        }
        
    }
    
}

extension infoandOkeyActionViewComponent {
    
    private func setupUI() {
        addSubview(image)
        addSubview(info)
        addSubview(line)
        addSubview(okey)
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(46)
            $0.top.equalToSuperview().offset(10)
        }
        info.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(image.snp.bottom).offset(24)
        }
        line.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-45)
        }
        okey.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(line.snp.bottom)
        }
    }
    
    @objc private func didButtonTapped() {
        action?(true)
    }
    
    func configure(viewModel: ViewModel) {
        image.image = viewModel.image
        info.text = viewModel.info
        info.textAlignment = viewModel.textAligment
        info.textColor = viewModel.textColor
        info.font = viewModel.font
        okey.setTitle(viewModel.buttonTitle, for: .normal)
        okey.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        self.layer.cornerRadius = viewModel.cornerRadius
        self.backgroundColor = viewModel.backgroundColor
        action = viewModel.action
    }
    
}

