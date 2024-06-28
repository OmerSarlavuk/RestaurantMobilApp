//
//  MealCategoryCell.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 3.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer
import Then


class MealCategoryCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    
    static let instance = "MealCategoryCell"
    
    var shimmeringAnimatedItems: [UIView] {[image, identifierView]}
    
    struct ViewModel {
        
        let image: String
        let identifier: String
        
        init(image: String, identifier: String) {
            self.image = image
            self.identifier = identifier
        }
        
    }
    
    lazy private var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.layer.cornerRadius = 100
        return view
    }()
    
    lazy private var identifierView = UIView().then{
        $0.backgroundColor = .clear
        $0.addSubview(identifier)
    }
    
    lazy private var identifier: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.cornerRadius = 15
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
    
}

extension MealCategoryCell {
    
    
    private func setupUI() {
        contentView.addSubview(image)
        contentView.addSubview(identifierView)
        self.backgroundColor = .tabbarLocationView
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        
        image.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        identifierView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(image.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
        identifier.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    
    func configure(viewModel: ViewModel) {
        let url = URL(string: viewModel.image)
        image.kf.setImage(with: url)
        identifier.text = viewModel.identifier
    }
    
    
}


