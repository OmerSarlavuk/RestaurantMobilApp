//
//  extension+indicatorComponent.swift
//  RestaurantMobilApp
//
//  Created by Ahlatci on 11.07.2024.
//

import UIKit
import SnapKit


extension infoandOkeyActionViewComponent {
    
    
    func start(view: UIView) {
        
        view.addSubview(self)
        
        self.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(50)
            $0.width.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    
}


