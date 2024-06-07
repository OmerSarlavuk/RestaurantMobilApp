//
//  CategoryMealDetailCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 6.06.2024.
//

import UIKit
import Then
import UIView_Shimmer
import SnapKit


protocol IngredientsHeight: AnyObject {
    func heightValue(height: CGFloat)
}


class CategoryMealDetailCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    static let key = "CategoryMealDetailCell"
    var shimmeringAnimatedItems: [UIView] {[titleMaterials, strIngredients]}
    var urls: (String, String)?
    weak var ingredientsProtocol: IngredientsHeight?
    
    lazy private var titleMaterials = UILabel().then{
        $0.text = "Materials"
        $0.textColor = .iconandIdentifierViewComponentColor2
        $0.font = .boldSystemFont(ofSize: 22)
    }
    
    lazy private var strIngredients: UILabel = {
       let label = UILabel()
        label.text = "-------------------------------------------------------------------------------------------------------------------------------"
        label.numberOfLines = 0
        label.textAlignment = .center
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
        
        let strIngredients: String
        let font: UIFont
        let textColor: UIColor
        let textAligment: NSTextAlignment
        let youtubeURL: String
        let websiteURL: String
        
        
        init(strIngredients: String, font: UIFont, textColor: UIColor, textAligment: NSTextAlignment, youtubeURL: String, websiteURL: String) {
            self.strIngredients = strIngredients
            self.font = font
            self.textColor = textColor
            self.textAligment = textAligment
            self.youtubeURL = youtubeURL
            self.websiteURL = websiteURL
        }
        
    }
    
}

extension CategoryMealDetailCell {
    
    private func setupUI() {
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        contentView.addSubview(titleMaterials)
        contentView.addSubview(strIngredients)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleMaterials.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(10)
        }
        strIngredients.snp.makeConstraints{
            $0.top.equalTo(titleMaterials.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(viewModel: ViewModel) {
        strIngredients.text = viewModel.strIngredients
        strIngredients.font = viewModel.font
        strIngredients.textColor = viewModel.textColor
        strIngredients.textAlignment = viewModel.textAligment
        self.urls = (viewModel.youtubeURL, viewModel.websiteURL)
        ingredientsProtocol?.heightValue(height: strIngredients.frame.height)
    }
     
}


