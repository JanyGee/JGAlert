//
//  JGAlert.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/25.
//

import Foundation
import UIKit

@objcMembers
public class JGAlert: NSObject {

    private struct AlertQueueItem {
        let id: UUID
        let config: JGAlertConfig
        let enqueueOrder: UInt64
    }

    private weak var previousWindow: UIWindow?
    private var alertWindow: UIWindow?
    private var alertQueue = ThreadSafeArray<AlertQueueItem>()
    private var currentPresentedAlertID: UUID?
    private var enqueueOrder: UInt64 = 0

    static let shared = JGAlert()

    private override init() {
        super.init()
    }

    // MARK: Private
    private func configureAlertWindow(_ window: UIWindow) {
        window.windowLevel = .alert
        window.backgroundColor = .clear
        window.accessibilityViewIsModal = true

        if window.rootViewController == nil {
            let rootViewController = UIViewController()
            rootViewController.view.backgroundColor = .clear
            window.rootViewController = rootViewController
        } else {
            window.rootViewController?.view.backgroundColor = .clear
        }
    }

    private func activeWindowScene() -> UIWindowScene? {
        if #available(iOS 13.0, *) {
            if let currentScene = previousWindow?.windowScene {
                return currentScene
            }

            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
        }

        return nil
    }

    private func ensureAlertWindow() {
        previousWindow = UIWindow.jg_keyWindow()

        if #available(iOS 13.0, *) {
            let targetScene = activeWindowScene()
            let needsNewWindow = alertWindow == nil || alertWindow?.windowScene !== targetScene

            if needsNewWindow {
                if let targetScene {
                    alertWindow = UIWindow(windowScene: targetScene)
                } else {
                    alertWindow = UIWindow(frame: UIScreen.main.bounds)
                }
            }
        } else if alertWindow == nil {
            alertWindow = UIWindow(frame: UIScreen.main.bounds)
        }

        if let alertWindow {
            configureAlertWindow(alertWindow)
        }
    }

    private func nextAlertItem() -> AlertQueueItem? {
        let queuedItems = alertQueue.snapshot()
        guard !queuedItems.isEmpty else { return nil }

        return queuedItems.max { lhs, rhs in
            if lhs.config.alertLevel == rhs.config.alertLevel {
                return lhs.enqueueOrder > rhs.enqueueOrder
            }

            return lhs.config.alertLevel < rhs.config.alertLevel
        }
    }

    private func dequeueAlert(id: UUID?) {
        if let id {
            alertQueue.remove { $0.id == id }
        } else if let currentPresentedAlertID {
            alertQueue.remove { $0.id == currentPresentedAlertID }
        } else if let firstQueuedID = alertQueue.snapshot().first?.id {
            alertQueue.remove { $0.id == firstQueuedID }
        }
    }

    private func _alertShow() {
        ensureAlertWindow()
        guard let queueItem = nextAlertItem() else { return }
        let alertConfig = queueItem.config
        guard let rootViewController = alertWindow?.rootViewController else { return }

        guard rootViewController.presentedViewController == nil else {
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

        currentPresentedAlertID = queueItem.id
        alertWindow?.isHidden = false
        alertWindow?.makeKeyAndVisible()
        rootViewController.present(alertController, animated: true)

        alertController.dismissComplete = {
            alertConfig.dismissBlock?()
            JGAlert.presentNextAlert(with: queueItem.id)
        }

        if alertConfig.durationDismiss > 0 {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(alertConfig.durationDismiss), repeats: false) { [weak alertController] _ in
                guard let alertController else { return }

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

    private func enqueue(config: JGAlertConfig, cancelBlock: (() -> Void)?, comfirmBlock: (() -> Void)?, dismissBlock: (() -> Void)?) {
        config.cancelBlock = cancelBlock
        config.comfirmBlock = comfirmBlock
        config.dismissBlock = dismissBlock

        enqueueOrder += 1

        let queueItem = AlertQueueItem(
            id: UUID(),
            config: config,
            enqueueOrder: enqueueOrder
        )

        alertQueue.append(queueItem)
        _alertShow()
    }

    // MARK: Public
    public class func alert(config: JGAlertConfig, cancelBlock: (() -> Void)?, comfirmBlock: (() -> Void)?, dismissBlock: (() -> Void)?) {
        let work = {
            JGAlert.shared.enqueue(config: config, cancelBlock: cancelBlock, comfirmBlock: comfirmBlock, dismissBlock: dismissBlock)
        }

        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    public class func alert(config: JGAlertConfig) {
        alert(config: config, cancelBlock: nil, comfirmBlock: nil, dismissBlock: nil)
    }

    private class func presentNextAlert(with id: UUID?) {
        JGAlert.shared.alertWindow?.isHidden = true
        JGAlert.shared.previousWindow?.makeKeyAndVisible()
        JGAlert.shared.dequeueAlert(id: id)
        JGAlert.shared.currentPresentedAlertID = nil
        JGAlert.shared._alertShow()
    }

    public class func presentNextAlert(_ config: JGAlertConfig?) {
        let work = {
            JGAlert.shared.alertWindow?.isHidden = true
            JGAlert.shared.previousWindow?.makeKeyAndVisible()

            if let config {
                JGAlert.shared.alertQueue.removeFirst { $0.config == config }
            } else {
                JGAlert.shared.dequeueAlert(id: nil)
            }

            JGAlert.shared.currentPresentedAlertID = nil
            JGAlert.shared._alertShow()
        }

        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
