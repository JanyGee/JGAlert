//
//  JGAlertViewController.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit

@objc public enum JGAlertStyle: Int {
    case alert
    case actionSheet
}

@objc public enum JGAlertTransitionType: Int {
    case fade
    case faceScale
    case dropDown
    case custom
}

final class JGAlertViewController: UIViewController {
    
    var backgroundView: UIView?
    var alertViewOriginY: CGFloat = 0
    var alertStyleEdging: CGFloat = 15
    var actionSheetStyleEdging: CGFloat = 0
    var backgoundTapDismissEnable: Bool = false {
        didSet {
            singleTap?.isEnabled = backgoundTapDismissEnable
        }
    }
    var backgroundColor: UIColor? = .black.withAlphaComponent(0.4)
    var dismissComplete: (()-> Void)?
    
    private(set) var alertView: UIView?
    private(set) var alertStyle: JGAlertStyle?
    private(set) var alertTransitionType: JGAlertTransitionType?
    private(set) var transitionAnimationClass: AnyClass?
    private weak var singleTap: UITapGestureRecognizer?
    private var alertViewCenterYConstraint: NSLayoutConstraint?
    private var alertViewCenterYOffset: CGFloat = 0
    private var isAppInBackground: Bool = false
    
    struct UIConstants {
        static var statusBarHeight: CGFloat {
            if #available(iOS 13.0, *) {
                let windowScene = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first(where: { $0.activationState == .foregroundActive })
                
                return windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
    }
    
    //MARK: init
    init(alertView: UIView? = nil, alertStyle: JGAlertStyle? = nil, alertTransitionType: JGAlertTransitionType? = nil, transitionAnimationClass: AnyClass? = nil) {
        self.alertView = alertView
        self.alertStyle = alertStyle
        self.alertTransitionType = alertTransitionType
        self.transitionAnimationClass = transitionAnimationClass
        
        super.init(nibName: nil, bundle: nil)
        self.configureController()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureController()
    }
    
    convenience init(alertView: UIView?) {
        self.init(alertView: alertView, alertStyle: .alert, alertTransitionType: .fade)
    }
    
    convenience init(alertView: UIView?, alertStyle: JGAlertStyle?) {
        self.init(alertView: alertView, alertStyle: alertStyle, alertTransitionType: .fade)
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .clear;
        
        self.addBackgroundView()
        self.addSingleTapGesture()
        self.configureAlertView()
        self.view.layoutIfNeeded()
        
        if alertStyle == .alert {
            NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if alertStyle == .alert {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addBackgroundView() {
        if self.backgroundView == nil {
            let view = UIView()
            view.backgroundColor = backgroundColor
            backgroundView = view
        }
        
        guard let backgroundView else { return }
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(backgroundView, at: 0)
        self.view.addConstraint(to: backgroundView, edgeInset: .zero)
    }
    
    private func configureController() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    private func addSingleTapGesture() {
        self.view.isUserInteractionEnabled = true
        backgroundView?.isUserInteractionEnabled = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        singleTap.isEnabled = backgoundTapDismissEnable
        
        backgroundView?.addGestureRecognizer(singleTap)
        self.singleTap = singleTap
    }
    
    private func configureAlertView() {
        guard let alertView = alertView else { return }
        
        alertView.isUserInteractionEnabled = true
        self.view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        switch alertStyle {
        case .alert:
            self.layoutAlertStyleView()
        default:
            self.layoutActionSheetStyleView()
            break
            
        }
    }
    
    @objc private func singleTap(_ sender: UITapGestureRecognizer) {
        self.dismissViewController(animated: true)
    }
    
    private func dismissViewController(animated: Bool = false) {
        self.dismiss(animated: animated, completion: dismissComplete)
    }
    
    //MARK: Public Method
    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated) { [weak self] in
            completion?()
            self?.dismissComplete?()
        }
    }
}

extension JGAlertViewController {
    //MARK: layout
    private func layoutAlertStyleView() {
        
        guard let alertView = alertView else { return }
        
        self.view.addConstraint(centerXToView: alertView, centerYToView: nil)
        self.configureAlertViewWidth()
        
        alertViewCenterYConstraint = self.view.addConstraint(centerYToView: alertView, constant: 0)
        
        if alertViewOriginY > 0 {
            alertView.layoutIfNeeded()
            alertViewCenterYOffset = alertViewOriginY - (CGRectGetHeight(self.view.frame) - CGRectGetHeight(alertView.frame)) / 2.0
            alertViewCenterYConstraint?.constant = alertViewCenterYOffset
        } else {
            alertViewCenterYOffset = 0
        }
    }
    
    private func layoutActionSheetStyleView() {
        guard let alertView = alertView else { return }

        if let widthConstraint = alertView.constraints.first(where: {
            $0.firstAttribute == .width
        }) {
            alertView.removeConstraint(widthConstraint)
        }

        view.addConstraint(
            with: alertView,
            topView: nil,
            leftView: view,
            bottomView: view,
            rightView: view,
            edgeInset: UIEdgeInsets(
                top: 0,
                left: actionSheetStyleEdging,
                bottom: 0,
                right: -actionSheetStyleEdging
            )
        )
        
        let height = alertView.frame.height
        if height > 0 {
            alertView.addConstraint(width: 0, height: height)
        }
        
        setupDismissGesture()
    }
    
    private func configureAlertViewWidth() {
        guard let alertView = alertView else { return }

        if alertView.frame.size != .zero {
            alertView.addConstraint(
                width: alertView.frame.width,
                height: alertView.frame.height
            )
            return
        }

        let hasWidthConstraint = alertView.constraints.contains {
            $0.firstAttribute == .width
        }

        if !hasWidthConstraint {
            let width = view.frame.width - 2 * alertStyleEdging
            alertView.addConstraint(width: width, height: 0)
        }
    }
    
    private func setupDismissGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        alertView?.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                alertView?.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended, .cancelled:
            if translation.y > 100 || velocity.y > 500 {
                self.dismissViewController(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.alertView?.transform = .identity
                }
            }
        default:
            break
        }
    }
}

extension JGAlertViewController {
    
    //MARK: notification
    @objc private func keyboardWillShow(_ notification: Notification) {
        if isAppInBackground || self.isViewLoaded == false || self.view.window == nil {
            return
        }
        
        guard
            let userInfo = notification.userInfo,
            let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        guard let alertView = alertView else { return }
        
        let alertViewBottomEdge = (view.frame.height - alertView.frame.size.height) / 2 - alertViewCenterYOffset
        let statusBarHeight = UIConstants.statusBarHeight
        let differ = keyboardRect.height - alertViewBottomEdge
        
        if alertViewCenterYConstraint?.constant == -differ - statusBarHeight {
            return
        }
        
        if differ >= 0 {
            if UIApplication.shared.applicationState != .active {
                return
            }
            
            alertViewCenterYConstraint?.constant = alertViewCenterYOffset - differ - statusBarHeight
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if isAppInBackground || self.isViewLoaded == false || self.view.window == nil {
            return
        }
        
        if UIApplication.shared.applicationState != .active {
            return
        }
        
        alertViewCenterYConstraint?.constant = alertViewCenterYOffset
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func appWillResignActive(_ notification: Notification) {
        isAppInBackground = true
    }
    
    @objc private func appDidEnterBackground(_ notification: Notification) {
        isAppInBackground = true
    }
    
    @objc private func appDidBecomeActive(_ notification: Notification) {
        isAppInBackground = false
    }
}

extension JGAlertViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        switch alertTransitionType {
        case .fade:
            return JGAlertFadeAnimation.alertAnimation(isPresenting: true)
        case .faceScale:
            return JGAlertScaleFadeAnimation.alertAnimation(isPresenting: true)
        case .dropDown:
            return JGAlertDropDownAnimation.alertAnimation(isPresenting: true)
        case .custom:
            return transitionAnimationClass?.alertAnimation(isPresenting: true, alertStyle: alertStyle!)
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        switch alertTransitionType {
        case .fade:
            return JGAlertFadeAnimation.alertAnimation(isPresenting: false)
        case .faceScale:
            return JGAlertScaleFadeAnimation.alertAnimation(isPresenting: false)
        case .dropDown:
            return JGAlertDropDownAnimation.alertAnimation(isPresenting: false)
        case .custom:
            return transitionAnimationClass?.alertAnimation(isPresenting: false, alertStyle: alertStyle!)
        default:
            return nil
        }
    }
}
