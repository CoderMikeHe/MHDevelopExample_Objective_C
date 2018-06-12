//
//  CMHSearchHistoryHeaderView.m
//  UTrading
//
//  Created by lx on 2018/4/23.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//  表头

#import "CMHSearchHistoryHeaderView.h"

@interface CMHSearchHistoryHeaderView ()
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;

/// deleteBtn
@property (nonatomic , readwrite , weak) UIButton *deleteBtn;
@end


@implementation CMHSearchHistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}





#pragma mark - Private Method

- (void)_deleteBtnDidClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistoryHeaderViewDidClickedDeleteItem:)]) {
        [self.delegate searchHistoryHeaderViewDidClickedDeleteItem:self];
    }
}


- (void)_setup{
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    /// 主题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = MHRegularFont_13;
    titleLabel.textColor = MHColorFromHexString(@"#333333");
    titleLabel.text = @"历史记录";
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /// 删除
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn setImage:MHImageNamed(@"details_card_trash_blue") forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(_deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(16);
        make.top.bottom.equalTo(self);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-12);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
}


@end
