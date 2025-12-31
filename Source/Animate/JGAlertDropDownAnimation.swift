//
//  JGAlertDropDownAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit
class JGAlertDropDownAnimation: JGBaseAnimation {
    override func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        if isPresenting {
            return 0.5
        } else {
            return 0.25
        }
    }
    
    override func presentAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .to) as? JGAlertViewController else { return }
        alertController.backgroundView?.alpha = 0
        
        switch alertController.alertStyle {
        case .alert:
            if let frame = alertController.alertView?.frame as? CGRect {
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: -CGRectGetMaxY(frame))
            }
        default:
            break
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5) {
            alertController.backgroundView?.alpha = 1
            alertController.alertView?.transform = .identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    override func dismissAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .from) as? JGAlertViewController else { return }
        
        UIView.animate(withDuration: 0.25) {
            alertController.backgroundView?.alpha = 0
            
            switch alertController.alertStyle {
            case .alert:
                alertController.alertView?.alpha = 0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            default:
                break
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
