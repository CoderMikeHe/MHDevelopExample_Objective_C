//
//  MHDivider.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDivider.h"

@implementation MHDivider

+ (instancetype)divider
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
    self.backgroundColor = MHGlobalBottomLineColor;
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
    
    
}


@end
