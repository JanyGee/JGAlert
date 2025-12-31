//
//  JGAlertConfig.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/25.
//

import Foundation
import UIKit

public enum JGAlertLevel: Int, Comparable {
    case low        = 100   // 非关键提示
    case normal     = 500   // 普通业务弹框
    case high       = 800   // 强提示
    case critical   = 1000  // 系统级、强制
    
    public static func < (lhs: JGAlertLevel, rhs: JGAlertLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

@objcMembers
public class JGAlertConfig: NSObject {
    public var alertStyle: JGAlertStyle = .alert //弹框样式
    public var alertTransitionType: JGAlertTransitionType = .fade //弹框动画
    public var backgoundTapDismissEnable: Bool = true //点击背景是否消失, 默认点击背景小说
    public var comfirmDismissEnable: Bool = true //点击确定是否弹框消失，默认消失
    public var durationDismiss: NSInteger = 0 //针对自动消失的弹框，需要设置弹框显示的时间
    public var alertViewOriginY: CGFloat = 0 //如果是alert，可以设置垂直方向的偏移位置
    public var alertStyleEdging: CGFloat = 15 //如果是alert，可以设置弹框左右两边的padding，默认15
    public var backgroundColor: UIColor = .black.withAlphaComponent(0.8) //背景色
    public var transitionAnimationClass: JGAlertAnimationFactory.Type?//自定义动画
    public var alertView: (UIView & JGAlertProtocol)?
    public var alertLevel: JGAlertLevel = .low //弹框的级别
    public var cancelBlock: (() -> Void)?
    public var comfirmBlock: (() -> Void)?
    public var dismissBlock: (() -> Void)?
}
