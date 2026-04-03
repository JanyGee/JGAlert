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
    @available(iOS 13.0, *)
    private static func _foregroundWindowScenes() -> [UIWindowScene] {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
    }

    private static func _keyWindow(from windowScene: UIWindowScene?) -> UIWindow? {
        guard let windowScene = windowScene else { return nil }

        return windowScene.windows.first(where: \.isKeyWindow)
    }

    // MARK: - Public
    static func jg_keyWindow() -> UIWindow? {

        if #available(iOS 13.0, *) {
            let activeScenes = _foregroundWindowScenes()

            if !jg_useNewBTDKeyWindow {
                return activeScenes.compactMap { _keyWindow(from: $0) }.first
            }

            if let keyWindow = activeScenes.compactMap({ _keyWindow(from: $0) }).first {
                return keyWindow
            }

            for scene in activeScenes {
                if let visibleWindow = scene.windows.first(where: {
                    !$0.isHidden && $0.windowLevel == .normal
                }) {
                    return visibleWindow
                }
            }

            return activeScenes.first?.windows.first

        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
