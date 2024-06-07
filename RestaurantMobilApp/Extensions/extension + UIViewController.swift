//
//  extension + UIViewController.swift
//  DenemeProje
//
//  Created by Ahlatci on 21.05.2024.
//

import UIKit

extension UIViewController {
    
    func openWithAnimation(openViewController: UIViewController, duration: CFTimeInterval, timingFunction: CAMediaTimingFunctionName, type: CATransitionType, subType: CATransitionSubtype, modalPresentationStyle: UIModalPresentationStyle) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction)
        transition.type = type
        transition.subtype = subType
        self.view.window!.layer.add(transition, forKey: nil)
        openViewController.modalPresentationStyle = modalPresentationStyle
        self.present(openViewController, animated: false)
    }
    
}

