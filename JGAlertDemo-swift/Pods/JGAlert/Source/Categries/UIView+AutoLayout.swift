//
//  UIView+AutoLayout.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit

extension UIView {

    // MARK: - Edge Constraints

    func addConstraint(to view: UIView, edgeInset: UIEdgeInsets) {
        addConstraint(
            with: view,
            topView: self,
            leftView: self,
            bottomView: self,
            rightView: self,
            edgeInset: edgeInset
        )
    }

    func addConstraint(with view: UIView,
                       topView: UIView?,
                       leftView: UIView?,
                       bottomView: UIView?,
                       rightView: UIView?,
                       edgeInset: UIEdgeInsets) {

        view.translatesAutoresizingMaskIntoConstraints = false

        if let topView {
            addConstraint(
                NSLayoutConstraint(
                    item: view,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: topView,
                    attribute: .top,
                    multiplier: 1,
                    constant: edgeInset.top
                )
            )
        }

        if let leftView {
            addConstraint(
                NSLayoutConstraint(
                    item: view,
                    attribute: .left,
                    relatedBy: .equal,
                    toItem: leftView,
                    attribute: .left,
                    multiplier: 1,
                    constant: edgeInset.left
                )
            )
        }

        if let rightView {
            addConstraint(
                NSLayoutConstraint(
                    item: view,
                    attribute: .right,
                    relatedBy: .equal,
                    toItem: rightView,
                    attribute: .right,
                    multiplier: 1,
                    constant: edgeInset.right
                )
            )
        }

        if let bottomView {
            addConstraint(
                NSLayoutConstraint(
                    item: view,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: bottomView,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: edgeInset.bottom
                )
            )
        }
    }

    // MARK: - Horizontal / Vertical

    func addConstraint(leftView: UIView,
                       toRightView rightView: UIView,
                       constant: CGFloat) {

        addConstraint(
            NSLayoutConstraint(
                item: leftView,
                attribute: .right,
                relatedBy: .equal,
                toItem: rightView,
                attribute: .left,
                multiplier: 1,
                constant: -constant
            )
        )
    }

    @discardableResult
    func addConstraint(topView: UIView,
                       toBottomView bottomView: UIView,
                       constant: CGFloat) -> NSLayoutConstraint {

        let constraint = NSLayoutConstraint(
            item: topView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: bottomView,
            attribute: .top,
            multiplier: 1,
            constant: -constant
        )

        addConstraint(constraint)
        return constraint
    }

    // MARK: - Size

    func addConstraint(width: CGFloat, height: CGFloat) {

        if width > 0 {
            addConstraint(
                NSLayoutConstraint(
                    item: self,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: width
                )
            )
        }

        if height > 0 {
            addConstraint(
                NSLayoutConstraint(
                    item: self,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .notAnAttribute,
                    multiplier: 1,
                    constant: height
                )
            )
        }
    }

    func addConstraintEqual(to view: UIView?,
                            widthToView wView: UIView?,
                            heightToView hView: UIView?) {

        if let wView {
            addConstraint(
                NSLayoutConstraint(
                    item: view as Any,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: wView,
                    attribute: .width,
                    multiplier: 1,
                    constant: 0
                )
            )
        }

        if let hView {
            addConstraint(
                NSLayoutConstraint(
                    item: view as Any,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: hView,
                    attribute: .height,
                    multiplier: 1,
                    constant: 0
                )
            )
        }
    }

    // MARK: - Center

    func addConstraint(centerXToView xView: UIView?,
                       centerYToView yView: UIView?) {

        if let xView {
            addConstraint(
                NSLayoutConstraint(
                    item: xView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0
                )
            )
        }

        if let yView {
            addConstraint(
                NSLayoutConstraint(
                    item: yView,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .centerY,
                    multiplier: 1,
                    constant: 0
                )
            )
        }
    }

    @discardableResult
    func addConstraint(centerYToView yView: UIView,
                       constant: CGFloat) -> NSLayoutConstraint {

        let constraint = NSLayoutConstraint(
            item: yView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: constant
        )

        addConstraint(constraint)
        return constraint
    }

    // MARK: - Remove Constraints

    func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        for constraint in constraints where constraint.firstAttribute == attribute {
            removeConstraint(constraint)
            break
        }
    }

    func removeConstraint(view: UIView, attribute: NSLayoutConstraint.Attribute) {
        for constraint in constraints
        where constraint.firstAttribute == attribute && constraint.firstItem as? UIView == view {
            removeConstraint(constraint)
            break
        }
    }

    func removeAllConstraints() {
        removeConstraints(constraints)
    }
}
