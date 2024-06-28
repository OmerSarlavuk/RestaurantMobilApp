//
//  Extension+UIStackView.swift
//  FatihDeneme
//
//  Created by Ö.Ş on 24.05.2024.
//

import UIKit

extension UIStackView {
    
    func setStackViewOptions(axis: NSLayoutConstraint.Axis, distribution: Distribution, spacing: CGFloat, aligment: Alignment) {
        self.axis = axis
        self.alignment = aligment
        self.distribution = distribution
        self.spacing = spacing
    }
    
}

