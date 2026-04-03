# JGAlert

<p align="center" >
  <img src="https://github.com/JanyGee/JGAlert/blob/main/demo.gif">
</p>

[![Version](https://img.shields.io/cocoapods/v/JGAlert.svg?style=flat)](http://cocoapods.org/pods/JGAlert)
[![License](https://img.shields.io/cocoapods/l/JGAlert.svg?style=flat)](http://cocoapods.org/pods/JGAlert)
[![Platform](https://img.shields.io/cocoapods/p/JGAlert.svg?style=flat)](http://cocoapods.org/pods/JGAlert)
[![Swift-5.0](http://img.shields.io/badge/Swift-5.0-blue.svg)]()

A lightweight custom alert & actionSheet for iOS.

## Installation

JGAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JGAlert"
```

## Usage

```swift
import JGAlert
```

## Methods

**public class func alert(config: JGAlertConfig, cancelBlock: (() -> Void)?, comfirmBlock: (() -> Void)?, dismissBlock: (() -> Void)?)**
```swift
let alertView = myView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

let config = JGAlertConfig()
config.alertView = alertView
config.alertTransitionType = .custom
config.transitionAnimationClass = JGDownUpAnimation.self
JGAlert.alert(config: config) {
    print("cancel")
} comfirmBlock: {
    print("comfir")
} dismissBlock: {
    print("dismiss")
}
```

**public class func alert(config: JGAlertConfig)**
```swift
let alertView = ActionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))

let config = JGAlertConfig()
config.alertView = alertView
config.alertStyle = .actionSheet
JGAlert.alert(config: config)
```

## Author

Jany Gee, 1321899953@qq.com

## License

JGAlert is available under the MIT license. See the LICENSE file for more info.
