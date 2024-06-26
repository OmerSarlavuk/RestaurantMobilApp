//
//  BasketItemCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 26.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer
import Kingfisher

class BasketItemCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    
    static let key = "BasketItemCell"
    
    var shimmeringAnimatedItems: [UIView] {[self]}
    
    lazy private var image: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy private var categoryName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 22)
        label.text = "##########"
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
        
        let image: String
        let mealName: String
        
        init(image: String, mealName: String) {
            self.image = image
            self.mealName = mealName
        }
        
    }
    
}

extension BasketItemCell {
    
    
    private func setupUI() {
        self.backgroundColor = .tabbarLocationView
        self.layer.cornerRadius = 15
        contentView.addSubview(image)
        contentView.addSubview(categoryName)
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints{
            $0.width.height.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        categoryName.snp.makeConstraints{
            $0.top.equalTo(image.snp.top).offset(-4)
            $0.leading.equalTo(image.snp.trailing).offset(8)
        }
    }
    
    func configure(viewModel: ViewModel) {
        
        let url = URL(string: viewModel.image)
        image.kf.setImage(with: url)
        categoryName.text = viewModel.mealName
        
    }
    
}


