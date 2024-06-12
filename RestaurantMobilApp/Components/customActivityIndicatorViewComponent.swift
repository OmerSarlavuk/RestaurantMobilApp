//
//  customActivityIndicatorViewComponent.swift
//  DenemeProje
//
//  Created by Ahlatci on 22.04.2024.
//

import UIKit
import SnapKit

class customActivityIndicatorViewComponent : UIView {
    
    lazy private var loaderImage   = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubview(loaderImage)
        setUI()
        setupConstraints()
    }
    
    private func setUI() {
        loaderImage.image       = .progress
        loaderImage.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        loaderImage.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    func startAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        loaderImage.layer.add(rotation, forKey: "spin")
    }


    func stopAnimation() {
        loaderImage.layer.removeAllAnimations()
    }
    
}

