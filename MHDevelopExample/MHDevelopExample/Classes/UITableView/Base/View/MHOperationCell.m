//
//  MHOperationCell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHOperationCell.h"
#import "MHTitleRightButton.h"

@interface MHOperationCell ()

/** 视频封面 */
@property (nonatomic , weak) MHImageView *videoCover;

/** 视频主题 */
@property (nonatomic , weak) YYLabel *titleLabel;

/** 播放字数 */
@property (nonatomic , weak) MHTitleRightButton *playNumsBtn;


@end


@implementation MHOperationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

/** 选中cell的时候调用 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // 非编辑状态下 直接退出
    if (!self.isEditing) return;
    
    // 非修改系统选中图标样式
    if (!self.isModifySelectionStyle) return;
    
    // 修改系统选择按钮的样式
    if (selected) {
        // 改变
        [self _changeCellSelectedImage];
    }
}
/** 长按cell高亮状态下 */
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    // 非编辑状态下 直接退出
    if (!self.isEditing) return;
    // 非修改系统选中图标样式
    if (!self.isModifySelectionStyle) return;
    
    if (highlighted) {
        // 改变
        [self _changeCellSelectedImage];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OperationCell";
    MHOperationCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
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
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    self.titleLabel.text = [NSString stringWithFormat:@"仙剑奇侠传 第%zd集",indexPath.row];
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 去掉选中的背景色
    UIView *selectedBackgroundView =  [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 视频封面
    MHImageView *videoCover = [MHImageView imageView];
    self.videoCover = videoCover;
    videoCover.userInteractionEnabled = NO;
    [MHWebImageTool setImageWithURL:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2092471158,1396207594&fm=23&gp=0.jpg" placeholderImage:MHImageNamed(@"home_videoCover") imageView:videoCover];
    [self.contentView addSubview:videoCover];
    
    
    // 主题
    YYLabel *titleLabel = [[YYLabel alloc] init];
    titleLabel.userInteractionEnabled = NO;
    titleLabel.text = @"仙剑奇侠传";
    titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = MHGlobalBlackTextColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 播放量
    MHTitleRightButton *playNumsBtn = [[MHTitleRightButton alloc] init];
    playNumsBtn.imageOffsetX = 0;
    [playNumsBtn setTitleColor:MHGlobalGrayTextColor forState:UIControlStateNormal];
    [playNumsBtn setImage:[UIImage imageNamed:@"CollectionVideo_playNums"] forState:UIControlStateNormal];
    [playNumsBtn setTitle:@"24.7万" forState:UIControlStateNormal];
    playNumsBtn.titleLabel.font = MHMediumFont(MHPxConvertPt(12.0f));
    playNumsBtn.backgroundColor = [UIColor clearColor];
    playNumsBtn.userInteractionEnabled = NO;
    self.playNumsBtn = playNumsBtn;
    [self.contentView addSubview:playNumsBtn];
}




#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局封面
    [self.videoCover mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.width.equalTo(self.videoCover.mas_height).multipliedBy(530.0f/400.0f);
    }];
    
    // 布局主题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.videoCover.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.top.equalTo(self.videoCover.mas_top);
        make.height.mas_equalTo([@"哈哈哈哈" mh_sizeWithFont:self.titleLabel.font].height+5);
    }];
    
    // 布局播放数目
    [self.playNumsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.videoCover.mas_bottom);
        make.height.mas_equalTo([@"哈哈哈哈" mh_sizeWithFont:self.playNumsBtn.titleLabel.font].height+5);
    }];
    
    
}



#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

#pragma mark - 辅助属性
/** 修改选中按钮的样式 */
- (void)_changeCellSelectedImage
{
    // 利用KVC 设置color
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIControl class]])
        {
            for (UIView *subview in view.subviews) {
                
                if ([subview isKindOfClass:[UIImageView class]]) {
                    // MHGlobalOrangeTextColor :浅橙色
                    [subview setValue:MHGlobalOrangeTextColor forKey:@"tintColor"];
                }
            }
        }
    }
}


@end
