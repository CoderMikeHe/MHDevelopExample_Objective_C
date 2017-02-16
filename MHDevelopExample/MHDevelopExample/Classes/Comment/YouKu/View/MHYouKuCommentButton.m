//
//  MHYouKuCommentButton.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuCommentButton.h"

@implementation MHYouKuCommentButton

+ (instancetype)commentButton
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}
#pragma mark - 公共方法



#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = MHFont(MHPxConvertPt(12.0f), NO);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    
}


#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    
    CGFloat titleLabelX = 15;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = self.mh_width -  titleLabelX*2;
    CGFloat titleLabelH = self.mh_height;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
}


@end
