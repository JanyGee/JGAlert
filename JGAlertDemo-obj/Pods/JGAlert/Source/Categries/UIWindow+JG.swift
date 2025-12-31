//
//  UIWindow+JG.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/27.
//

import UIKit

extension UIWindow {
    // MARK: - Switch (对应 btd_useNewBTDKeyWindow)
    static var jg_useNewBTDKeyWindow: Bool = true

    // MARK: - Private
    private static func _keyWindow(from windowScene: UIWindowScene?) -> UIWindow? {
        guard let windowScene = windowScene else { return nil }

        for window in windowScene.windows {
            if window.isKeyWindow {
                return window
            }
        }
        return nil
    }

    // MARK: - Public
    static func jg_keyWindow() -> UIWindow? {

        if #available(iOS 13.0, *) {

            if !jg_useNewBTDKeyWindow {
                return UIApplication.shared.keyWindow
            }

            var keyWindow: UIWindow?
            var activeWindowSceneCount = 0

            let scenes = UIApplication.shared.connectedScenes
            for scene in scenes {
                if scene.activationState == .foregroundActive,
                   let windowScene = scene as? UIWindowScene {

                    activeWindowSceneCount += 1

                    if keyWindow == nil {
                        keyWindow = _keyWindow(from: windowScene)
                    }
                }
            }

            // 多个前台 scene，取当前 focused 的
            if activeWindowSceneCount > 1 {
                keyWindow = _keyWindow(
                    from: UIApplication.shared.keyWindow?.windowScene
                )
            }

            // fallback：遍历 windows
            if keyWindow == nil {
                for window in UIApplication.shared.windows {
                    if window.isKeyWindow {
                        keyWindow = window
                        break
                    }
                }
            }

            // deprecated 但可用
            if keyWindow == nil,
               UIApplication.shared.keyWindow?.isKeyWindow == true {
                keyWindow = UIApplication.shared.keyWindow
            }

            // 最终兜底：AppDelegate.window
            if keyWindow == nil,
               let delegate = UIApplication.shared.delegate,
               delegate.responds(to: Selector(("window"))),
               let window = delegate.window {
                keyWindow = window
            }

            return keyWindow

        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
