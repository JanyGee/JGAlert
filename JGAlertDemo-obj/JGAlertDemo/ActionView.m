//
//  ActionView.m
//  JGAlertDemo
//
//  Created by Jany on 2025/12/31.
//

#import "ActionView.h"

@implementation ActionView
@synthesize onCancel = _onCancel;
@synthesize onConfirm = _onConfirm;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.layer.maskedCorners =
        kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;

        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.backgroundColor = UIColor.orangeColor;
        button1.frame = CGRectMake(10, 10, 80, 30);
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        button1.layer.cornerRadius = 5;
        [button1 addTarget:self
                     action:@selector(button1Click:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];

        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.backgroundColor = UIColor.orangeColor;
        button2.frame = CGRectMake(frame.size.width - 90, 10, 80, 30);
        [button2 setTitle:@"确定" forState:UIControlStateNormal];
        button2.layer.cornerRadius = 5;
        [button2 addTarget:self
                     action:@selector(button2Click:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
    }
    return self;
}

- (void)button1Click:(UIButton *)sender {
    if (self.onCancel) {
        self.onCancel();
    }
}

- (void)button2Click:(UIButton *)sender {
    if (self.onConfirm) {
        self.onConfirm();
    }
}

@end
