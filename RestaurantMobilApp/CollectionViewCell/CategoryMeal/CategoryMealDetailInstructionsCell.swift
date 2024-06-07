//
//  CategoryMealDetailInstructionsCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 7.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer


protocol CategoryMealDetailInstructionsCellHeight: AnyObject {
    func sendHeight(height: CGFloat)
}


class CategoryMealDetailInstructionsCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    
    static let key = "CategoryMealDetailInstructionsCell"
    weak var cellHeightProtocol: CategoryMealDetailInstructionsCellHeight?
        
    var shimmeringAnimatedItems: [UIView] {[titlePreparation, strInstructions]}
    
    lazy private var titlePreparation = UILabel().then{
        $0.text = "Preparation Of"
        $0.textColor = .iconandIdentifierViewComponentColor2
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    
    lazy private var strInstructions: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        debugPrint("init ---> \(strInstructions.frame.height)")
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    struct ViewModel {
        
        let strInstructions: String
        
        init(strInstructions: String) {
            self.strInstructions = strInstructions
        }
        
    }
    
}

extension CategoryMealDetailInstructionsCell {
    
    
    private func setupUI() {
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        contentView.addSubview(titlePreparation)
        contentView.addSubview(strInstructions)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        titlePreparation.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
        }
        strInstructions.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalTo(titlePreparation.snp.bottom).offset(24)
        }
        
    }
    
    
    func configure(viewModel: ViewModel) {
        self.strInstructions.text = viewModel.strInstructions
        cellHeightProtocol?.sendHeight(height: self.strInstructions.frame.height)
        debugPrint("configure ---> \(strInstructions.frame.height)")
    }
    
    
}


