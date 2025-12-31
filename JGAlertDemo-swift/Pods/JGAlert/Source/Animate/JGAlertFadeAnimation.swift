//
//  JGAlertFadeAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit

class JGAlertFadeAnimation: JGBaseAnimation {
    override func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        if isPresenting {
            return 0.45
        } else {
            return 0.25
        }
    }
    
    override func presentAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .to) as? JGAlertViewController else { return }
        alertController.backgroundView?.alpha = 0
        
        switch alertController.alertStyle {
        case .alert:
            alertController.alertView?.alpha = 0
            alertController.alertView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        default:
            if let height = alertController.alertView?.frame.size.height as? CGFloat {
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: height)
            }
            break
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: 0.25) {
            alertController.backgroundView?.alpha = 1.0
            
            switch alertController.alertStyle {
            case .alert:
                alertController.alertView?.alpha = 1
                alertController.alertView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            default:
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: -10)
                break
            }
            
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                alertController.alertView?.transform = .identity
            } completion: { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    override func dismissAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .from) as? JGAlertViewController else { return }
        
        UIView.animate(withDuration: 0.25) {
            switch alertController.alertStyle {
            case .alert:
                alertController.alertView?.alpha = 0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            default:
                if let height = alertController.alertView?.frame.size.height as? CGFloat {
                    alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: height)
                }
                break
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
