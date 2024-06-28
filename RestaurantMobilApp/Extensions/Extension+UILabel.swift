//
//  Extension+UILabel.swift
//  FatihDeneme
//
//  Created by Ö.Ş on 24.05.2024.
//

import UIKit

extension UILabel {
    
    func setLabelOptions(text: String, textColor: UIColor, font: UIFont, numberOfLines: Int) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines
    }
    
}
