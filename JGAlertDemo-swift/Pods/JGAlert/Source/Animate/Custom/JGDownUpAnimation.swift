//
//  JGDownUpAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/25.
//

import UIKit

class JGDownUpAnimation: JGBaseAnimation,JGAlertAnimationFactory {
    static func alertAnimation(isPresenting: Bool, alertStyle: JGAlertStyle?) -> (any UIViewControllerAnimatedTransitioning)? {
        return self.init(isPresenting: isPresenting)
    }
    
    override func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.3
    }
    
    override func presentAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .to)
                    as? JGAlertViewController,
                  let alertView = alertController.alertView
            else { return }

            let container = transitionContext.containerView
            container.addSubview(alertController.view)

            alertController.backgroundView?.alpha = 0
            alertView.transform = CGAffineTransform(
                translationX: 0,
                y: container.bounds.height
            )

            UIView.animate(
                withDuration: 0.3,
                animations: {
                    alertController.backgroundView?.alpha = 1
                    alertView.transform = .identity
                },
                completion: { _ in
                    transitionContext.completeTransition(true)
                }
            )
    }
    
    override func dismissAnimateTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        guard let alertController = transitionContext.viewController(forKey: .from)
                    as? JGAlertViewController,
                  let alertView = alertController.alertView
            else { return }

            UIView.animate(
                withDuration: 0.25,
                animations: {
                    alertController.backgroundView?.alpha = 0
                    alertView.transform = CGAffineTransform(
                        translationX: 0,
                        y: transitionContext.containerView.bounds.height
                    )
                },
                completion: { _ in
                    transitionContext.completeTransition(true)
                }
            )
    }
}
