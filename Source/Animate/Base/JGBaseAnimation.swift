//
//  JGBaseAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit

protocol JGAlertAnimationFactory: AnyObject {
    static func alertAnimation(
        isPresenting: Bool,
        alertStyle: JGAlertStyle?
    ) -> (any UIViewControllerAnimatedTransitioning)?
}

class JGBaseAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    private(set) var isPresenting: Bool
    
    required init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    class func alertAnimation(isPresenting: Bool) -> JGBaseAnimation {
        return self.init(isPresenting: isPresenting)
    }
    
    class func alertAnimation(isPresenting: Bool, alertStyle: JGAlertStyle) -> JGBaseAnimation {
        return self.init(isPresenting: isPresenting)
    }
    
    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    //MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
}
