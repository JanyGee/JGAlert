# JGAlert 1.0.4

`JGAlert` is an iOS alert scheduler and popup queue manager for apps that need better popup coordination.

This release focuses on open source presentation, discoverability, and integration improvements.

## Highlights

- added Swift Package Manager support
- refreshed the README with clearer positioning around popup queueing and priority scheduling
- improved the demo GIF for a cleaner GitHub landing experience
- updated CocoaPods metadata for better discoverability

## Why JGAlert

Many apps do not have a popup UI problem. They have a popup scheduling problem.

When onboarding tips, upgrade prompts, risk alerts, activity popups, and rating dialogs compete for the same screen, `JGAlert` helps manage them with queueing and priority-based presentation.

## Core Capabilities

- queue multiple alerts and action sheets
- schedule dialogs by priority
- support custom alert views and action sheets
- customize transition animations
- support auto dismiss, background tap dismiss, and drag-to-dismiss
- work with both Swift and Objective-C projects

## Installation

### CocoaPods

```ruby
pod "JGAlert"
```

### Swift Package Manager

```swift
.package(url: "https://github.com/JanyGee/JGAlert.git", from: "1.0.4")
```

## Links

- GitHub: https://github.com/JanyGee/JGAlert
- CocoaPods: https://cocoapods.org/pods/JGAlert

If this library helps your project, a star is always appreciated.
