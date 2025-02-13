//
//  CategoryMealTopCell.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 5.06.2024.
//

import UIKit
import SnapKit
import Kingfisher
import Then
import UIView_Shimmer


protocol orderButton: AnyObject {
    func orderButtonTapped(dto: FavoriteDto)
}

class CategoryMealTopCell: UICollectionViewCell, ShimmeringViewProtocol {
 
    static let key = "CategoryMealTopCell"
    var shimmeringAnimatedItems: [UIView] {[mealImage, favoriteView, orderView ]}
    var favoriteDto: FavoriteDto?
    weak var delegate: orderButton?
    
    lazy private var parentView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mealImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
        
    }()
    
    lazy private var favoriteButton: UIButton = {
        let favoriteButton = UIButton().then{
            $0.backgroundColor = .clear
            $0.setImage(.favorite, for: .normal)
            $0.setImage(.favoriteDolu, for: .selected)
            $0.tag = 1
            $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        }
        return favoriteButton
    }()
    
    lazy private var favoriteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        return view
    }()

    lazy private var orderButton: UIButton = {
        let button = UIButton().then{
            $0.backgroundColor = .clear
            $0.setImage(.share, for: .normal)
            $0.tag = 2
            $0.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        }
        return button
    }()
    
    
    lazy private var orderView: UIView = {
        //View height-width values -> 50
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        return view
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

extension CategoryMealTopCell {
    
    private func setupUI() {
        contentView.addSubview(parentView)
        parentView.addSubview(mealImage)
        parentView.addSubview(favoriteView)
        parentView.addSubview(orderView)
        favoriteView.addSubview(favoriteButton)
        orderView.addSubview(orderButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        parentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        mealImage.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        favoriteView.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.trailing.equalToSuperview().offset(-62)
            $0.top.equalToSuperview().offset(10)
        }
        orderView.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(10)
        }
        favoriteButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        orderButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        // Button tag value ;
        
        //case 1: Favorite, case 2: Order
        
        button.isSelected = !button.isSelected
        guard let dto = favoriteDto else { return }
        
        switch button.tag {
            
        case 1:
            
            let local = LocalDataBaseProcess()
            
            if button.isSelected {
            
                local.setDATA(value: "\(dto.imageURL)\r\n\(dto.mealName)\r\n\(dto.mealId)", key: dto.mealName)
                
            } else {
                
                local.removeDATA(key: dto.mealName)
                
            }
            
        case 2:
            
            delegate?.orderButtonTapped(dto: dto)
        
        default:
            print()
            
        }
        
        
    }
    
    
    func control() {
        guard let dto = favoriteDto else { return }
        
        let local = LocalDataBaseProcess()
        
        let check = local.getDATA(key: dto.mealName)
        
        if !check.isEmpty {
            favoriteButton.isSelected = true
            debugPrint("r -> \(check)")
        }

    }
    
}

