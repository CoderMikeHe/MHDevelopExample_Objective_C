//
//  MHYouKuVerticalSeparateButton.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuVerticalSeparateButton.h"

@interface MHYouKuVerticalSeparateButton ()

// 左侧分割线
@property (nonatomic , weak) MHImageView *leftSeparate;

// 右侧分割线
@property (nonatomic , weak) MHImageView *rightSeparate;
@end


@implementation MHYouKuVerticalSeparateButton



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}




#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    MHImageView *leftSeparate = [MHImageView imageView];
    leftSeparate.backgroundColor = MHGlobalBottomLineColor;
    [self addSubview:leftSeparate];
    self.leftSeparate = leftSeparate;
    
    MHImageView *rightSeparate = [MHImageView imageView];
    rightSeparate.backgroundColor = MHGlobalBottomLineColor;
    rightSeparate.hidden= leftSeparate.hidden = YES;
    [self addSubview:rightSeparate];
    self.rightSeparate = rightSeparate;
    
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    [self.leftSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.width.mas_equalTo(MHGlobalBottomLineHeight);
        make.height.mas_equalTo(MHPxConvertPt(13.0f));
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    
    [self.rightSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
        make.width.mas_equalTo(MHGlobalBottomLineHeight);
        make.height.mas_equalTo(MHPxConvertPt(13.0f));
        make.centerY.equalTo(self.mas_centerY);
        
    }];
}

#pragma mark - 公共方法
- (void)hideLeftSeparate
{
    self.leftSeparate.hidden = YES;
}

- (void)hideRightSeparate
{
    self.rightSeparate.hidden = YES;
}

- (void) showLeftSeparate
{
    self.leftSeparate.hidden = NO;
}

- (void) showRightSeparate
{
    self.rightSeparate.hidden = NO;
}


@end
