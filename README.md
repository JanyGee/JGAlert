# JGAlert

<p align="center" >
  <img src="[https://github.com/JanyGee/JGAlert/demo.gif](https://github.com/JanyGee/JGAlert/blob/main/demo.gif)">
</p>

[![CI Status](http://img.shields.io/travis/amayne/JGString.svg?style=flat)](https://travis-ci.org/amayne/JGString)
[![Version](https://img.shields.io/cocoapods/v/JGString.svg?style=flat)](http://cocoapods.org/pods/JGString)
[![License](https://img.shields.io/cocoapods/l/JGString.svg?style=flat)](http://cocoapods.org/pods/JGString)
[![Platform](https://img.shields.io/cocoapods/p/JGString.svg?style=flat)](http://cocoapods.org/pods/JGString)
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

**between(left, right)**
```swift
"<a>foo</a>".between(left: "<a>", "</a>") // "foo"
"<a><a>foo</a></a>".between(left: "<a>", "</a>") // "<a>foo</a>"
"<a>foo".between(left: "<a>", "</a>") // nil
"Some strings } are very {weird}, dont you think?".between(left: "{", "}") // "weird"
"<a></a>".between(left: "<a>", "</a>") // nil
"<a>foo</a>".between(left: "<a>", "<a>") // nil
```

## Author

Jany Gee, 1321899953@qq.com

## License

JGAlert is available under the MIT license. See the LICENSE file for more info.
