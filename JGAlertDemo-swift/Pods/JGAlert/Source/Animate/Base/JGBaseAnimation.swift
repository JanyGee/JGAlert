//
//  JGBaseAnimation.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit

public class JGBaseAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    @objc public var isPresenting: Bool
    
    required public init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    @objc(alertAnimationWithPresenting:)
    public class func alertAnimation(isPresenting: Bool) -> JGBaseAnimation {
        return self.init(isPresenting: isPresenting)
    }
    
    @objc(alertAnimationWithPresenting:alertStyle:)
    public class func alertAnimation(isPresenting: Bool, alertStyle: JGAlertStyle) -> JGBaseAnimation {
        return self.init(isPresenting: isPresenting)
    }
    
    public func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) { }
     
    public func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) { }
     
    // MARK: UIViewControllerAnimatedTransitioning
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
     
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.presentAnimateTransition(transitionContext)
        } else {
            self.dismissAnimateTransition(transitionContext)
        }
    }
}
