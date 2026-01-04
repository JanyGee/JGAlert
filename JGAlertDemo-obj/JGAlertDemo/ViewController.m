//
//  ViewController.m
//  JGAlertDemo
//
//  Created by Jany on 2025/12/31.
//

#import "ViewController.h"
#import "AlertView.h"
#import "AutoDismisView.h"
#import "ActionView.h"

@import JGAlert;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)click:(id)sender {
    [self alertView];
    [self alertAutoDismiss];
    [self alertAction];
    [self alertView];
}

- (void)alertView {
    AlertView *alertView = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

    JGAlertConfig *config = [[JGAlertConfig alloc] init];
    config.alertView = alertView;
    config.alertTransitionType = JGAlertTransitionTypeCustom;
    config.transitionAnimationClass = JGDownUpAnimation.class;
    [JGAlert alertWithConfig:config
                cancelBlock:^{
                    NSLog(@"cancel");
                }
               comfirmBlock:^{
                    NSLog(@"confirm");
                }
               dismissBlock:^{
                    NSLog(@"dismiss");
                }];
}

#pragma mark - ActionSheet

- (void)alertAction {
    ActionView *alertView =
    [[ActionView alloc] initWithFrame:CGRectMake(0, 0,
                                                 UIScreen.mainScreen.bounds.size.width,
                                                 500)];

    JGAlertConfig *config = [[JGAlertConfig alloc] init];
    config.alertView = alertView;
    config.alertStyle = JGAlertStyleActionSheet;
    
    [JGAlert alertWithConfig:config];
}

#pragma mark - 自动消失

- (void)alertAutoDismiss {
    AutoDismisView *alertView =
    [[AutoDismisView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

    JGAlertConfig *config = [[JGAlertConfig alloc] init];
    config.alertView = alertView;
    config.alertTransitionType = JGAlertTransitionTypeDropDown;
    config.backgoundTapDismissEnable = NO;
    config.durationDismiss = 5;

    [JGAlert alertWithConfig:config];
}

@end
