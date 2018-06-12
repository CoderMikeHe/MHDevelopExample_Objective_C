//
//  CMHExampleTableTestCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExampleTableTestCell.h"
#import "CMHExampleTableTest.h"
@interface CMHExampleTableTestCell ()
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// titleLabel
@property (nonatomic , readwrite , weak) UIView *divider;
/// rightArrow
@property (nonatomic , readwrite , weak) UIImageView *rightArrow;
/// example
@property (nonatomic , readwrite , strong) CMHExampleTableTest *example;
/// 选中按钮 (编辑删除 ， 收藏删除)
@property (nonatomic , readwrite , weak) UIButton *selectedBtn;
@end

@implementation CMHExampleTableTestCell

#pragma mark - Public Method
- (void)configureModel:(CMHExampleTableTest *)example{
    self.example = example;
    self.titleLabel.text = example.title;
    
    if (example.isEditState) { /// 编辑状态
        self.rightArrow.hidden = YES;
        self.selectedBtn.hidden = NO;
        self.selectedBtn.selected = example.isSelected;
    }else{
        self.rightArrow.hidden = NO;
        self.selectedBtn.hidden = YES;
        self.selectedBtn.selected = NO;
    }
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows{
    self.divider.hidden = (indexPath.row == (rows -1));
}

/// 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CMHExampleTableTestCell";
    CMHExampleTableTestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}



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
    
    /// 分割线
    UIView *divider = [[UIView alloc] init];
    self.divider = divider;
    divider.backgroundColor = MHGlobalBottomLineColor;
    [self.contentView addSubview:divider];
    
    /// rightArrow
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:MHImageNamed(@"uf_filter_next")];
    self.rightArrow = rightArrow;
    [self.contentView addSubview:rightArrow];
    
    /// 选中按钮 40x40
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedBtn setImage:MHImageNamed(@"details_unchecked") forState:UIControlStateNormal];
    [selectedBtn setImage:MHImageNamed(@"details_selected") forState:UIControlStateSelected];
    self.selectedBtn = selectedBtn;
    selectedBtn.userInteractionEnabled = NO;
    selectedBtn.hidden = YES;
    [self.contentView addSubview:selectedBtn];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.lessThanOrEqualTo(self.rightArrow.mas_left).with.offset(-10);
        make.top.equalTo(self.contentView).with.offset(12);
        make.bottom.equalTo(self.contentView).with.offset(-12);
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
    
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.contentView);
    }];
}



@end
