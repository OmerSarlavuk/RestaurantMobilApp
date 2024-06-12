//
//  InstructionsStepViewComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 12.06.2024.
//

import UIKit
import SnapKit
import Then

class InstructionsStepViewComponent: UIView {
    
    lazy private var title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var change: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.setImage(.down, for: .normal)
        button.setImage(.up, for: .selected)
        return button
    }()
    
    lazy var identifier: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    struct ViewModel {
        let title: String
        let textColor: UIColor
        let font: UIFont
        let identifier: String
        let textColorI: UIColor
        let fontI: UIFont
        let textAligment: NSTextAlignment
        let handleTap: VoidCallback
    }
    
    private func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.iconandIdentifierViewComponentColor1.cgColor
        addSubview(title)
        addSubview(change)
        addSubview(identifier)
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
        }
        change.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(32)
        }
        identifier.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.leading.equalTo(title)
            $0.trailing.equalTo(change)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(viewModel: ViewModel) {
        title.text = viewModel.title
        title.textColor = viewModel.textColor
        title.font = viewModel.font
        identifier.text = viewModel.identifier
        identifier.textColor = viewModel.textColorI
        identifier.font = viewModel.fontI
        identifier.textAlignment = viewModel.textAligment
        self.onTap(handler: viewModel.handleTap)
    }
    
    func getIdentifierHeight() -> CGFloat {
           let maxSize = CGSize(width: self.identifier.frame.width, height: CGFloat.greatestFiniteMagnitude)
           let height = identifier.sizeThatFits(maxSize).height
           return height
       }
    
    typealias VoidCallback = () -> Void
    
}

extension UIView {
    
    func onTapp(handler: @escaping VoidCallback) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        objc_setAssociatedObject(self, &tapHandlerKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        if let handler = objc_getAssociatedObject(self, &tapHandlerKey) as? VoidCallback {
            handler()
        }
    }
}

private var tapHandlerKey: UInt8 = 0



