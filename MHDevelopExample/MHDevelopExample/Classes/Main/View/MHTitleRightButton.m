//
//  MHTitleRightButton.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTitleRightButton.h"

@implementation MHTitleRightButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _margin = 5.0f;
        _imageOffsetX = 5.0f;
    }
    return self;
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    
    [self setNeedsLayout];
}

- (void)setImageOffsetX:(CGFloat)imageOffsetX
{
    _imageOffsetX = imageOffsetX;
    [self setNeedsLayout];
}



#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    self.imageView.mh_x = self.imageOffsetX;
    
    self.titleLabel.mh_x = CGRectGetMaxX(self.imageView.frame) + self.margin;
    
}

@end
