//
//  MHHorizontalMode1Cell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/23.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalMode1Cell.h"
#import "MHHorizontal.h"
@interface MHHorizontalMode1Cell ()
/// btn
@property (nonatomic, readwrite, weak) UIButton *btn;
@end

@implementation MHHorizontalMode1Cell

#pragma mark - Setter
- (void)setHorizontal:(MHHorizontal *)horizontal{
    _horizontal = horizontal;
    [self.btn setTitle:horizontal.name forState:UIControlStateNormal];
    self.btn.layer.borderColor = horizontal.isSelected ? [UIColor pinkColor].CGColor : [UIColor lightGrayColor].CGColor;
    self.btn.layer.borderWidth = horizontal.isSelected ? 3 : 1;
}


#pragma mark - Action
- (void)_btnDidClicked:(UIButton *)sender{
    /// 回调数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCellTapAction:)]) {
        [self.delegate collectionViewCellTapAction:self];
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = self.backgroundColor = [UIColor clearColor];
}

/// 创建子控件
- (void)_setupSubviews{
    /// btn
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = MHRegularFont_16;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    [self.contentView addSubview:btn];
    /// 默认边框
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btn = btn;
    
    /// 事件处理
    [btn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{}

/// 布局子控件(手写frame)
- (void)layoutSubviews{
    [super layoutSubviews];
    self.btn.frame = self.bounds;
}

@end
