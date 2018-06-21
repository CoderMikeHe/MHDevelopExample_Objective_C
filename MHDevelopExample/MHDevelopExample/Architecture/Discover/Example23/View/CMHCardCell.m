//
//  CMHCardCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/12.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHCardCell.h"
#import "CMHCard.h"
@interface CMHCardCell ()
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// imageView
@property (nonatomic , readwrite , weak) UIImageView *imageView;
/// card
@property (nonatomic , readwrite , strong) CMHCard *card;
@end


@implementation CMHCardCell
#pragma mark - Public Method
- (void)configureModel:(CMHCard *)card{
    
    self.card = card;
    
    self.titleLabel.text = card.title;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:card.imageUrl] placeholder:MHImageNamed(@"placeholder_image") options:CMHWebImageOptionAutomatic completion:NULL];
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
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor greenColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = true;
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
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

#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
}
@end
