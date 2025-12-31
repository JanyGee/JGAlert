//
//  JGAlertProtocol.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/27.
//
import Foundation

@objc public protocol JGAlertProtocol {
    var onConfirm: (() -> Void)? { get set }
    var onCancel: (() -> Void)? { get set }
}
