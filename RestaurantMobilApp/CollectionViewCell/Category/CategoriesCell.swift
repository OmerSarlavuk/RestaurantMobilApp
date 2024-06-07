//
//  CategoriesCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 30.05.2024.
//

import UIKit
import SnapKit
import Kingfisher
import UIView_Shimmer


class CategoriesCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    static let instance = "CategoriesCell"
    
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
    
    lazy private var identifier: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "-------------------"
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
        let categoryName: String
        let identifier: String
        
        init(image: String, categoryName: String, identifier: String) {
            self.image = image
            self.categoryName = categoryName
            self.identifier = identifier
        }
        
    }
    
}

extension CategoriesCell {
    
    private func setupUI() {
        self.backgroundColor = .tabbarLocationView
        self.layer.cornerRadius = 15
        contentView.addSubview(image)
        contentView.addSubview(categoryName)
        contentView.addSubview(identifier)
        setupConstraints()
    }

    
    private func setupConstraints() {
        image.snp.makeConstraints{
            $0.width.height.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        categoryName.snp.makeConstraints{
            $0.top.equalTo(image.snp.top).offset(4)
            $0.leading.equalTo(image.snp.trailing).offset(10)
        }
        identifier.snp.makeConstraints{
            $0.leading.equalTo(categoryName.snp.leading)
            $0.top.equalTo(categoryName.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(viewModel: ViewModel) {
        let url = URL(string: viewModel.image)
        image.kf.setImage(with: url)
        categoryName.text = viewModel.categoryName
        identifier.text = viewModel.identifier
    }
    
}


