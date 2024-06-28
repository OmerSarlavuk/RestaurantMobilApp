//
//  BasketItemCell.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 26.06.2024.
//

import UIKit
import SnapKit
import UIView_Shimmer
import Kingfisher
import Then

protocol sendValue: AnyObject {
    func send(indexPath: IndexPath, mealName: String)
    func addNote()
}

class BasketItemCell: UICollectionViewCell, ShimmeringViewProtocol {

    static let key = "BasketItemCell"
    
    var category_Name: String?
    var shimmeringAnimatedItems: [UIView] {[self]}
    
    var resultValue: Int = 1 { didSet { value.text = "\(resultValue)"}}
    
    var delegate: sendValue?
    let local = LocalDataBaseProcess()
    var index: IndexPath?
    
    lazy private var image: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.backgroundColor = .clear
        return view
    }()
    
    
    lazy private var categoryName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "##########"
        return label
    }()
    
    lazy private var minus: UIButton = {
        let button = UIButton()
        button.setImage(.minus, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    lazy private var plus: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var result = UIView().then{$0.layer.cornerRadius = 18; $0.backgroundColor = .white}
    
    lazy private var value: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy private var addNote: UIButton = {
       let button = UIButton()
        button.setImage(.addNote, for: .normal)
        button.setTitle("Add note product", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didButtonTapped), for: .touchUpInside)
        button.setTitleColor(.darkGray, for: .normal)
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
        contentView.addSubview(minus)
        contentView.addSubview(result)
        result.addSubview(value)
        contentView.addSubview(plus)
        contentView.addSubview(addNote)
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
            $0.leading.equalTo(image.snp.trailing).offset(24)
        }
        minus.snp.makeConstraints{
            $0.trailing.equalTo(result.snp.leading).offset(-6)
            $0.centerY.equalTo(plus.snp.centerY)
            $0.width.height.equalTo(32)
        }
        result.snp.makeConstraints{
            $0.centerY.equalTo(plus.snp.centerY)
            $0.trailing.equalTo(plus.snp.leading).offset(-6)
            $0.width.height.equalTo(36)
        }
        value.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
        plus.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().offset(-6)
            $0.width.height.equalTo(32)
        }
        addNote.snp.makeConstraints{
            $0.leading.equalTo(categoryName.snp.leading)
            $0.centerY.equalTo(image.snp.centerY)
        }
    }
    
    func configure(viewModel: ViewModel) {
        
        let url = URL(string: viewModel.image)
        image.kf.setImage(with: url)
        categoryName.text = viewModel.mealName
        category_Name = viewModel.mealName
        
        let piece = local.getDATA(key: "\(viewModel.mealName)piece")
        guard let piec = Int(piece) else { return }
        resultValue = !piece.isEmpty ? piec : 1
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        guard let mealName = category_Name else { return }
        
        //Burada hafızaya atma işlemi gerçekleşecek - ve + ya basılınca miktar değişecek onu tutacağiz
        //MARK: Example -> key: "\(mealName)piece" şeklinde
        
        if button == minus {

            if resultValue == 1 {
                guard let ip = self.index else { return }
                delegate?.send(indexPath: ip, mealName: mealName)
                return
            } else {
                resultValue -= 1
                local.setDATA(value: "\(resultValue)", key: "\(mealName)piece")
            }
            
        }
        
        if button == plus {
            resultValue += 1
            local.setDATA(value: "\(resultValue)", key: "\(mealName)piece")
        }
        
        if button == addNote {
            self.delegate?.addNote()
        }
        
    }
    
    
}


