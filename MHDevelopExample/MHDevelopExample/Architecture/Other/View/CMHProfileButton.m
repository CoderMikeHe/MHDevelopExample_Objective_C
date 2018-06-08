//
//  CMHProfileButton.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHProfileButton.h"

@implementation CMHProfileButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.layer.cornerRadius = 18;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderWidth = .5;
        self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /// 04 是指第四个Demo [CMHExample04ViewController]
        [self setTitle:@"4" forState:UIControlStateNormal];
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.titleLabel.font = MHRegularFont(8);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.layer.cornerRadius = 5;
        self.titleLabel.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    /// 固定宽高
    frame.size = CGSizeMake(44, 44);
    [super setFrame:frame];
}

- (void)setHighlighted:(BOOL)highlighted{}

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    /// 强制设置按钮图片 的大小
    self.imageView.frame = CGRectMake(0, 0, 36, 36);
    self.imageView.mh_x = 0;
    self.imageView.mh_centerY = self.frame.size.height *.5;
    
    /// 设置label的Frame
    self.titleLabel.mh_size = CGSizeMake(10, 10);
    self.titleLabel.center = CGPointMake(self.imageView.right, self.imageView.top);
}

@end
