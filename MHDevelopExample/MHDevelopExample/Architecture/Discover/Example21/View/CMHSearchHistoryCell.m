//
//  CMHSearchHistoryCell.m
//  UTrading
//
//  Created by lx on 2018/4/23.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//

#import "CMHSearchHistoryCell.h"

@interface CMHSearchHistoryCell ()
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;

///
@property (nonatomic , readwrite , copy) NSString *history;


@end

@implementation CMHSearchHistoryCell

- (void)configureModel:(NSString *)history{
    self.history = history;
    self.titleLabel.text = history;
}


#pragma mark - Private Method
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



- (void)_setup{
    self.contentView.backgroundColor = MHColor(249, 249, 249);
    
    self.contentView.layer.cornerRadius = 15;;
    self.contentView.layer.masksToBounds = YES;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = MHColorFromHexString(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = MHRegularFont_12;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
@end
