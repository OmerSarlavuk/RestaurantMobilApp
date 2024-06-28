//
//  Extension+UIView.swift
//  FatihDeneme
//
//  Created by Ö.Ş on 24.05.2024.
//

import UIKit
import SnapKit

extension UIView {
    
    func onTap(handler: @escaping VoidCallback) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &AssociatedKeys.tapHandler, handler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let handler = objc_getAssociatedObject(self, &AssociatedKeys.tapHandler) as? () -> Void else { return }
        handler()
    }
    
    
    func tabbarAnimate() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .linear)
        transition.type = .fade
        transition.subtype = .fromLeft
        self.layer.add(transition, forKey: nil)
    }
    
    
    func nextPage(asChildViewController viewController: UIViewController, subType: CATransitionSubtype, duringViewController: UIViewController) {
        duringViewController.addChild(viewController)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = subType
        self.layer.add(transition, forKey: nil)
        self.addSubview(viewController.view)
        viewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        viewController.didMove(toParent: duringViewController.self)
    }
    
}

private struct AssociatedKeys {
    static var tapHandler = "tapHandler"
}


