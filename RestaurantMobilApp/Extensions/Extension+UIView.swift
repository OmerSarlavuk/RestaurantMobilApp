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
    
    func showErrorMessage(viewModel: infoandOkeyActionViewComponent.ViewModel) {
        
        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialLight))
        let alert = infoandOkeyActionViewComponent()
        
        self.addSubview(visualView)
        visualView.contentView.addSubview(alert)
        
        visualView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        alert.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(48)
            $0.trailing.equalToSuperview().offset(-48)
            $0.height.equalTo(200)
        }
        
        alert.configure(viewModel: infoandOkeyActionViewComponent.ViewModel(
            image:  viewModel.image,
            info: viewModel.info,
            textAligment: viewModel.textAligment,
            textColor: viewModel.textColor,
            font: viewModel.font,
            buttonTitle: viewModel.buttonTitle,
            buttonTitleColor: viewModel.buttonTitleColor,
            cornerRadius: viewModel.cornerRadius,
            backgroundColor: viewModel.backgroundColor,
            action: { state in
                if state {
                    visualView.removeFromSuperview()
                }
            }))

    }
    
}

private struct AssociatedKeys {
    static var tapHandler = "tapHandler"
}


