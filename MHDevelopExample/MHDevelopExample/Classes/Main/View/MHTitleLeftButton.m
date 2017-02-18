//
//  MHTitleLeftButton.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTitleLeftButton.h"

@implementation MHTitleLeftButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _margin = 5.0f;
        _titleOffsetX = 5.0f;
    }
    return self;
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    
    [self setNeedsLayout];
}

- (void)setTitleOffsetX:(CGFloat)titleOffsetX
{
    _titleOffsetX = titleOffsetX;
    [self setNeedsLayout];
}



#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    self.titleLabel.mh_x = self.titleOffsetX;
    
    self.imageView.mh_x = CGRectGetMaxX(self.titleLabel.frame) + self.margin;
    
}


@end
