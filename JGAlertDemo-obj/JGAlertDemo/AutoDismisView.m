//
//  AutoDismisView.m
//  JGAlertDemo
//
//  Created by Jany on 2025/12/31.
//

#import "AutoDismisView.h"

@interface AutoDismisView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation AutoDismisView
@synthesize onCancel = _onCancel;
@synthesize onConfirm = _onConfirm;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;

        UILabel *label =
        [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 100,
                                                  frame.size.height / 2 - 15,
                                                  200, 30)];
        label.text = @"自动消失";
        label.textColor = UIColor.blackColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

        self.label = label;
    }
    return self;
}


@end
