//
//  OpenAiCell.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 11.06.2024.
//

import UIKit
import SnapKit


class OpenAiCell: UICollectionViewCell {
    
    
    static let key = "OpenAiCell"
    
    lazy private var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    lazy private var content: UILabel = {
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
    }
    
    struct ViewModel {
        
        let content: [String]
        let image: UIImage?
        
        init(content: [String], image: UIImage) {
            self.content = content
            self.image = image
        }
        
    }
    
}

extension OpenAiCell {
    
    private func setupUI() {
        contentView.addSubview(image)
        contentView.addSubview(content)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        image.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(150)
        }
        content.snp.makeConstraints{
            $0.leading.equalTo(image.snp.leading)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(image.snp.bottom).offset(24)
        }
        
    }
    
    func configure(viewModel: ViewModel) {
        
        if let image = viewModel.image {
            
            self.image.image = image
            
        } else {
            self.image.isHidden = true
            image.snp.updateConstraints{
                $0.width.height.equalTo(1)
            }
        }
        
        self.content.text = viewModel.content.joined(separator: "\n\n\n")
        
    }
    
}


