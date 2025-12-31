//
//  ViewController.swift
//  JGAlertDemo
//
//  Created by Jany on 2025/12/24.
//

import UIKit
import JGAlert

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let config1 = JGAlertConfig()
        let config2 = JGAlertConfig()
        let config3 = JGAlertConfig()
        let config4 = JGAlertConfig()
        
        var arr = [config1, config2, config3, config4]

        //let element = config1

        arr.removeAll { $0 == config1 }
    }

    @IBAction func click(_ sender: Any) {
        self.alertView()
        self.alertAutoDismiss()
        self.alertAction()
        self.alertView()
    }
    
    func alertView() {
        let alertView = myView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        let config = JGAlertConfig()
        config.alertView = alertView
        JGAlert.alert(config: config) {
            print("cancel")
        } comfirmBlock: {
            print("comfir")
        } dismissBlock: {
            print("dismiss")
        }

    }
    
    func alertAction() {
        let alertView = ActionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))
        
        let config = JGAlertConfig()
        config.alertView = alertView
        config.alertStyle = .actionSheet
        JGAlert.alert(config: config)
    }
    
    func alertAutoDismiss() {
        let alertView = AutoDismisView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        let config = JGAlertConfig()
        config.alertView = alertView
        config.alertTransitionType = .dropDown
        config.backgoundTapDismissEnable = false
        config.durationDismiss = 5
        JGAlert.alert(config:config)
    }
    
}


class myView: UIView,JGAlertProtocol {
    var onConfirm: (() -> Void)?
    
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let button1 = UIButton(type: .custom)
        button1.backgroundColor = .orange
        button1.frame = CGRect(x: 10, y: frame.size.height - 40, width: 80, height: 30)
        button1.addTarget(self, action: #selector(button1Click(_:)), for: .touchUpInside)
        button1.setTitle("取消", for: .normal)
        button1.layer.cornerRadius = 5
        self.addSubview(button1)
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = .orange
        button2.frame = CGRect(x: frame.size.width - 90, y: frame.size.height - 40, width: 80, height: 30)
        button2.addTarget(self, action: #selector(button2Click(_:)), for: .touchUpInside)
        button2.setTitle("确定", for: .normal)
        button2.layer.cornerRadius = 5
        self.addSubview(button2)
    }
    
    
    @objc private func button1Click(_ sender: UIButton) {
        onCancel?()
    }
    
    @objc private func button2Click(_ sender: UIButton) {
        onConfirm?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ActionView: UIView,JGAlertProtocol {
    
    var onConfirm: (() -> Void)?
    
    var onCancel: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        let button1 = UIButton(type: .custom)
        button1.backgroundColor = .orange
        button1.frame = CGRect(x: 10, y: 10, width: 80, height: 30)
        button1.addTarget(self, action: #selector(button1Click(_:)), for: .touchUpInside)
        button1.setTitle("取消", for: .normal)
        button1.layer.cornerRadius = 5
        self.addSubview(button1)
        
        let button2 = UIButton(type: .custom)
        button2.backgroundColor = .orange
        button2.frame = CGRect(x: frame.size.width - 90, y: 10, width: 80, height: 30)
        button2.addTarget(self, action: #selector(button2Click(_:)), for: .touchUpInside)
        button2.setTitle("确定", for: .normal)
        button2.layer.cornerRadius = 5
        self.addSubview(button2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func button1Click(_ sender: UIButton) {
        onCancel?()
    }
    
    @objc private func button2Click(_ sender: UIButton) {
        onConfirm?()
    }
}

class AutoDismisView: UIView,JGAlertProtocol {
    
    var onConfirm: (() -> Void)?
    
    var onCancel: (() -> Void)?
    
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let label = UILabel(frame: CGRect(x: frame.size.width / 2 - 100, y: frame.size.height / 2 - 15, width: 200, height: 30))
        label.text = "自动消失"
        label.textColor = .black
        label.textAlignment = .center
        self.addSubview(label)
        
        self.label = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
