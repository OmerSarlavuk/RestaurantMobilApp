//
//  Extension+UIButton.swift
//  FatihDeneme
//
//  Created by Ahlatci on 24.05.2024.
//

import UIKit

extension UIButton {
    
    func setButtonOptions(backgroundColor: UIColor, cornerRadius: CGFloat, title: String, titleColor: UIColor, image: UIImage) {
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setImage(image, for: .normal)
    }
    
}

