# JGAlert Launch Copy

This file is a ready-to-use promotion draft for platforms like Juejin, Zhihu, CSDN, V2EX, X, or Xiaohongshu.

## Post Title Ideas

- iOS 多弹窗太乱了？我开源了一个弹窗队列调度库
- 我写了一个 iOS 弹框调度器，专门解决多个弹窗抢占的问题
- 弹窗不是 UI 问题，是调度问题：开源一个 iOS Popup Queue 库
- JGAlert: An iOS alert scheduler for apps with too many popups

## Chinese Long Post

最近整理了一个自己在项目里用过的弹窗库，开源成了 `JGAlert`。

它解决的不是“怎么画一个弹框”，而是更常见的业务问题:

- App 里弹框太多
- 多个业务弹框会同时触发
- 登录奖励、隐私协议、活动弹窗、风控提醒、评分引导互相抢展示
- 普通弹框不该盖过强提示弹框

所以我做了一个专门管理弹窗调度的 iOS 库：`JGAlert`。

它现在支持：

- 弹窗队列管理
- 弹窗优先级调度
- `Alert` / `ActionSheet` 统一管理
- 自定义转场动画
- 点击背景关闭
- 自动消失
- 下滑关闭
- Swift / Objective-C 都能接

比较适合这些场景：

- 运营弹窗比较多的 App
- 有很多 onboarding / 引导弹窗的项目
- 需要对风险弹窗、系统级提示做优先级管理的业务
- 不想在各个页面散落 `present(...)` 调用的团队

仓库地址：

`https://github.com/JanyGee/JGAlert`

如果你也遇到过“多个弹框一起弹”的问题，欢迎提 issue 或 star。

## Chinese Short Post

开源了一个 iOS 弹窗调度库 `JGAlert`，主要解决 App 内多个弹框同时出现时的冲突问题，支持弹窗队列、优先级、自定义动画、自动消失和 `Alert` / `ActionSheet` 统一管理。

适合运营弹窗多、引导弹窗多、风控弹窗有优先级的项目。

Repo:
`https://github.com/JanyGee/JGAlert`

## English Short Post

I open sourced `JGAlert`, an iOS alert scheduler and popup queue manager for apps that have too many popups competing for the screen.

It supports:

- popup queueing
- priority-based scheduling
- custom alert and action sheet views
- custom transitions
- auto dismiss and drag-to-dismiss

Repo:
`https://github.com/JanyGee/JGAlert`

## Suggested Tags

- iOS
- Swift
- Objective-C
- UIKit
- 弹窗
- 弹框
- 开源
- CocoaPods
- SwiftPM
