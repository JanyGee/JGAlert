# JGAlert 1.0.4 Launch Post

This file contains ready-to-paste copy for announcing `JGAlert 1.0.4`.

## Chinese Long Post

最近把我自己项目里一直在用的一个弹窗库整理出来，正式作为开源库继续维护，名字叫 `JGAlert`。

它主要解决的不是“怎么画一个弹框”，而是业务里更头疼的那个问题：

- App 里弹框太多
- 多个业务弹框会同时触发
- 登录奖励、隐私协议、活动弹窗、风控提醒、评分引导会互相抢展示
- 普通弹框不应该盖过高优先级弹框

所以我把它做成了一个专门管理弹窗调度的 iOS 库：`JGAlert`。

`1.0.4` 这次主要做了几件事：

- 补上了 Swift Package Manager 支持
- 重写了 README，让定位更清晰
- 更新了 GitHub 首页的演示动图
- 调整了 CocoaPods 元数据，方便被搜到

库本身目前支持：

- 弹窗队列管理
- 弹窗优先级调度
- `Alert` / `ActionSheet` 统一管理
- 自定义转场动画
- 点击背景关闭
- 自动消失
- 下滑关闭
- Swift / Objective-C 双支持

我觉得它比较适合这些场景：

- 运营弹窗很多的 App
- onboarding / 引导弹窗比较多的项目
- 风控提醒、强提示、普通弹窗需要分优先级的业务
- 想把散落在各页面的 `present(...)` 收口成统一入口的团队

如果你也遇到过“多个弹框一起弹”的问题，欢迎看看这个库，也欢迎提 issue 或 star：

GitHub:
https://github.com/JanyGee/JGAlert

CocoaPods:
https://cocoapods.org/pods/JGAlert

## Chinese Short Post

开源了一个 iOS 弹窗调度库 `JGAlert`，专门解决 App 内多个弹框同时出现时的冲突问题，支持弹窗队列、优先级、自定义动画、自动消失和 `Alert` / `ActionSheet` 统一管理。

`1.0.4` 这次补了 SwiftPM、README 和新的演示动图。

GitHub:
https://github.com/JanyGee/JGAlert

CocoaPods:
https://cocoapods.org/pods/JGAlert

## GitHub / X Short Post

I just released `JGAlert 1.0.4`, an iOS alert scheduler and popup queue manager for apps with too many popups competing for the screen.

This update adds:

- Swift Package Manager support
- a refreshed README
- a cleaner demo GIF
- better CocoaPods metadata

GitHub:
https://github.com/JanyGee/JGAlert

CocoaPods:
https://cocoapods.org/pods/JGAlert

## Suggested Chinese Titles

- 我把项目里的弹窗调度器开源了，顺手发了 JGAlert 1.0.4
- iOS 多弹窗太乱了？我开源了一个弹窗队列库
- 弹窗不是 UI 问题，是调度问题：JGAlert 1.0.4 发布

## Suggested Tags

- iOS
- Swift
- Objective-C
- UIKit
- CocoaPods
- SwiftPM
- 开源
- 弹窗
- 弹框
- 组件库
