//
//  JGAlert.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/25.
//

import Foundation
import UIKit

class JGAlert {
    
    private var previousWindow: UIWindow?
    private var alertWindow: UIWindow?
    private var alertQueue = ThreadSafeArray<JGAlertConfig>()
    static let shared = JGAlert()
    
    private init() {
        previousWindow = UIWindow.jg_keyWindow()
        
        if #available(iOS 13.0, *) {

            let activeScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }

            if let scene = activeScene {
                alertWindow = UIWindow(windowScene: scene)
            } else {
                alertWindow = UIWindow(frame: UIScreen.main.bounds)
            }

        } else {
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
        }
        
        alertWindow?.windowLevel = .alert
        alertWindow?.backgroundColor = .clear
        alertWindow?.accessibilityViewIsModal = true
        alertWindow?.rootViewController = UIViewController.init()
        alertWindow?.rootViewController?.view.backgroundColor = .clear
    }
    
    // MARK: Private
    private func _alertShow() {
        guard let alertConfig = _upcomingDisplayConfig() else { return }
        guard let rootVC = alertWindow?.rootViewController else { return }
        
        guard rootVC.presentedViewController == nil else {
            return
        }

        let alertController = JGAlertViewController(
            alertView: alertConfig.alertView,
            alertStyle: alertConfig.alertStyle,
            alertTransitionType: alertConfig.alertTransitionType,
            transitionAnimationClass: alertConfig.transitionAnimationClass
        )

        alertController.backgroundColor = alertConfig.backgroundColor
        alertController.backgoundTapDismissEnable = alertConfig.backgoundTapDismissEnable
        alertController.alertViewOriginY = alertConfig.alertViewOriginY
        alertController.alertStyleEdging = alertConfig.alertStyleEdging

        alertWindow?.isHidden = false
        alertWindow?.makeKeyAndVisible()
        rootVC.present(alertController, animated: true)

        alertController.dismissComplete = {[weak alertConfig] in
            alertConfig?.dismissBlock?()
            JGAlert.presentNextAlert(alertConfig)
        }
        
        if alertConfig.durationDismiss > 0 {
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(alertConfig.durationDismiss), repeats: false) { [weak alertController] _ in
                guard let alertController = alertController else { return }
                alertController.dismissViewController(animated: true) {
                    alertConfig.cancelBlock?()
                }
            }
            
        } else {
            
            alertConfig.alertView?.onCancel = { [weak alertController, weak alertConfig] in
                alertController?.dismissViewController(animated: true) {
                    alertConfig?.cancelBlock?()
                }
            }
            
            alertConfig.alertView?.onConfirm = { [weak alertController, weak alertConfig] in
             
                if alertConfig?.comfirmDismissEnable == true {
                    alertController?.dismissViewController(animated: true) {
                        alertConfig?.comfirmBlock?()
                    }
                } else {
                    alertConfig?.comfirmBlock?()
                }
            }
        }
    }
    
    private func _upcomingDisplayConfig () -> JGAlertConfig? {
        return alertQueue.max { $0.alertLevel < $1.alertLevel }
    }
    
    // MARK: Public
    public class func alert(config: JGAlertConfig, cancelBlock: (() -> Void)?, comfirmBlock: (() -> Void)?, dismissBlock: (() -> Void)?) {
        
        config.cancelBlock = cancelBlock
        config.comfirmBlock = comfirmBlock
        config.dismissBlock = dismissBlock
        
        JGAlert.shared.alertQueue.append(config)
        JGAlert.shared._alertShow()
    }
    
    public class func alert(config: JGAlertConfig) {
        alert(config:config, cancelBlock:nil, comfirmBlock:nil, dismissBlock:nil)
    }
    
    public class func presentNextAlert(_ config:JGAlertConfig?) {
        JGAlert.shared.alertWindow?.isHidden = true
        JGAlert.shared.previousWindow?.makeKeyAndVisible()
        
        if config == nil {
            JGAlert.shared.alertQueue.removeFirst()
        } else {
            JGAlert.shared.alertQueue.removeAll(config!)
        }

        JGAlert.shared._alertShow()
    }
    
}
