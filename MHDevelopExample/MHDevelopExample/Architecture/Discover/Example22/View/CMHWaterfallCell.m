//
//  CMHWaterfallCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHWaterfallCell.h"
#import "CMHWaterfall.h"

@interface CMHWaterfallCell ()
/// waterfall
@property (nonatomic , readwrite , strong) CMHWaterfall *waterfall;
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// imageView
@property (nonatomic , readwrite , weak) UIImageView *imageView;
@end


@implementation CMHWaterfallCell
- (void)configureModel:(CMHWaterfall *)waterfall{
    self.waterfall = waterfall;
    
    self.titleLabel.text = waterfall.title;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:waterfall.imageUrl] placeholder:MHImageNamed(@"placeholder_image") options:CMHWebImageOptionAutomatic completion:NULL];
}

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
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    /// 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = MHRegularFont_14;
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.bottom.and.right.equalTo(self.contentView);
    }];
    
}
@end
