//
//  MealCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 3.06.2024.
//

import UIKit
import SnapKit
import Kingfisher
import UIView_Shimmer


class MealCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    static let key = "MealCell"
    
    
    var shimmeringAnimatedItems: [UIView] {[image]}
    
    
    
    private let visualEffect: UIVisualEffectView = {
        let ve = UIVisualEffectView()
        return ve
    }()
    
    
    //İmage nesnesi dışarıdan configure edilecek.
    private let image: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()

    //Label text, font, textColor, aligment gibi özellikleri configure edilecektir.
    private let visualTitle: UILabel = {
       let label = UILabel()
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
        
        let image: String//link
        let effect: UIBlurEffect
        let title: String
        let font: UIFont
        let textColor: UIColor
        let textAligment: NSTextAlignment
        
        init(image: String, effect: UIBlurEffect, title: String, font: UIFont, textColor: UIColor, textAligment: NSTextAlignment) {
            self.image = image
            self.title = title
            self.font = font
            self.textColor = textColor
            self.textAligment = textAligment
            self.effect = effect
        }
        
    }
    
    
}

extension MealCell {
    
    private func setupUI() {
        contentView.addSubview(image)
        image.addSubview(visualEffect)
        visualEffect.contentView.addSubview(visualTitle)
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        visualEffect.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(image).dividedBy(4)
        }
        visualTitle.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(viewModel: ViewModel) {
        
        let url = URL(string: viewModel.image)
        image.kf.setImage(with: url)
        visualEffect.effect = viewModel.effect
        visualTitle.text = viewModel.title
        visualTitle.font = viewModel.font
        visualTitle.textColor = viewModel.textColor
        visualTitle.textAlignment = viewModel.textAligment
        
    }
    
}


