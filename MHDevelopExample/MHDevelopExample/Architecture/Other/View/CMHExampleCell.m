//
//  CMHExampleCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExampleCell.h"
#import "CMHExample.h"
@interface CMHExampleCell ()

/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// subtitleLabel
@property (nonatomic , readwrite , weak) UILabel *subtitleLabel;
/// titleLabel
@property (nonatomic , readwrite , weak) UIView *divider;
/// rightArrow
@property (nonatomic , readwrite , weak) UIImageView *rightArrow;

/// example
@property (nonatomic , readwrite , strong) CMHExample *example;

@end



@implementation CMHExampleCell

#pragma mark - Public Method
- (void)configureModel:(CMHExample *)example{
    self.example = example;
    
    self.titleLabel.text = example.title;
    self.subtitleLabel.text = example.subtitle;
    
}


/// 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CMHExampleCell";
    CMHExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


#pragma mark - Private Method

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    self.backgroundColor = UIColor.whiteColor;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    /// 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = MHRegularFont_17;
    titleLabel.textColor = MHColorFromHexString(@"#333333");
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    /// 副标题
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.font = MHRegularFont_16;
    subtitleLabel.textColor = MHColorFromHexString(@"#A5B1C3");
    self.subtitleLabel = subtitleLabel;
    [self.contentView addSubview:subtitleLabel];
    
    /// 分割线
    UIView *divider = [[UIView alloc] init];
    self.divider = divider;
    divider.backgroundColor = MHGlobalBottomLineColor;
    [self.contentView addSubview:divider];
    
    /// rightArrow
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:MHImageNamed(@"uf_filter_next")];
    self.rightArrow = rightArrow;
    [self.contentView addSubview:rightArrow];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.lessThanOrEqualTo(self.rightArrow.mas_left).with.offset(-10);
        make.top.equalTo(self.contentView).with.offset(12);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.lessThanOrEqualTo(self.rightArrow.mas_left).with.offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
    }];
    
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.contentView);
    }];
}

@end
