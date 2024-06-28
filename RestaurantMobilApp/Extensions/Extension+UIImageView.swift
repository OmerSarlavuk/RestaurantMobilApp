//
//  Extension+UIImageView.swift
//  FatihDeneme
//
//  Created by Ö.Ş on 24.05.2024.
//

import UIKit

extension UIImageView {
    
    func setImageViewOptions(contentMode: UIView.ContentMode, backgroundColor: UIColor, image: UIImage) {
        self.contentMode = contentMode
        self.backgroundColor = backgroundColor
        self.image = image
    }
    
}

