//
//  JGAlertScaleFadeAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/25.
//

import UIKit

class JGAlertScaleFadeAnimation: JGBaseAnimation {
    override func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }
    
    override func presentAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .to) as? JGAlertViewController else { return }
        alertController.backgroundView?.alpha = 0
        
        switch alertController.alertStyle {
        case .alert:
            alertController.alertView?.alpha = 0
            alertController.alertView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        default:
            if let frame = alertController.alertView?.frame as? CGRect {
                alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: CGRectGetHeight(frame))
            }
            break
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(alertController.view)
        
        UIView.animate(withDuration: 0.3) {
            alertController.backgroundView?.alpha = 1
            
            switch alertController.alertStyle {
            case .alert:
                alertController.alertView?.alpha = 1.0
                alertController.alertView?.transform = .identity
            default:
                alertController.alertView?.transform = .identity
                break
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    override func dismissAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .from) as? JGAlertViewController else { return }
        
        UIView.animate(withDuration: 0.3) {
            alertController.backgroundView?.alpha = 0
            
            switch alertController.alertStyle {
            case .alert:
                alertController.alertView?.alpha = 0
                alertController.alertView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            default:
                if let frame = alertController.alertView?.frame as? CGRect {
                    alertController.alertView?.transform = CGAffineTransform(translationX: 0, y: CGRectGetHeight(frame))
                }
                break
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }

    }
    
}
