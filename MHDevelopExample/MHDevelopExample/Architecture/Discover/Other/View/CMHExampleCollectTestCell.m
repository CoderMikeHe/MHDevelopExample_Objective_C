//
//  CMHExampleCollectTestCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExampleCollectTestCell.h"
#import "CMHExampleCollectTest.h"
@interface CMHExampleCollectTestCell ()
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// example
@property (nonatomic , readwrite , strong) CMHExampleCollectTest *example;
@end


@implementation CMHExampleCollectTestCell
#pragma mark - Public Method
- (void)configureModel:(CMHExampleCollectTest *)example{
    self.example = example;
    self.titleLabel.text = example.title;
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

#pragma mark - 事件处理Or辅助方法

#pragma mark - Private Method
- (void)_setup{
    self.contentView.backgroundColor = MHRandomColor;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    /// 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = MHRegularFont_14;
    titleLabel.textColor = MHColorFromHexString(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
