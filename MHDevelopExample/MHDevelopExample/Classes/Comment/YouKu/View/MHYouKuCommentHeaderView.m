//
//  MHYouKuCommentHeaderView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuCommentHeaderView.h"
#import "MHYouKuCommentButton.h"
#import "MHYouKuCommentItem.h"


@interface MHYouKuCommentHeaderView ()

/** titleView*/
@property (nonatomic , weak) UIView *titleView;

/** 评论 */
@property (nonatomic , weak) UILabel *commentLabel;

/** 评论总数 */
@property (nonatomic , weak) UILabel *commentNumsLabel;

/** 热门和最新 */
@property (nonatomic , weak) UIButton *topicTypeBtn;

/** 中间分割线 */
@property (nonatomic , weak) MHDivider *middleLine ;

/** 头像 */
@property (nonatomic , weak) MHImageView *avatarView;


/** commentView **/
@property (nonatomic , weak) UIView *commentView ;

/** 评论按钮 */
@property (nonatomic , weak) MHYouKuCommentButton *commentBtn;

/** 底部分割线 */
@property (nonatomic , weak) MHDivider *bottomLine ;

@end


@implementation MHYouKuCommentHeaderView

+ (instancetype)commentHeaderView
{
    return [[self alloc] init];
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"VideoCommentHeader";
    MHYouKuCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
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
- (void)setCommentItem:(MHYouKuCommentItem *)commentItem
{
    _commentItem= commentItem;
    
    self.commentLabel.text = commentItem.title;
    
    self.commentNumsLabel.text = [NSString stringWithFormat:@"%zd" , commentItem.commentCount];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"已有%zd条评论，快来说说你的感想吧",commentItem.commentCount] forState:UIControlStateNormal];
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 设置主题View
    [self _setupTitleView];
    
    // 设置评论View
    [self _setupCommentView];
    
}

// 初始化评论View
- (void) _setupTitleView
{
    // 评论View
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:titleView];
    self.titleView = titleView;
    
    
    // 评论label
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.font = MHFont(MHPxConvertPt(15.0f), NO);
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.textColor = MHGlobalBlackTextColor;
    self.commentLabel = commentLabel;
    [titleView addSubview:commentLabel];
    
    
    // 评论数
    UILabel *commentNumsLabel = [[UILabel alloc] init];
    commentNumsLabel.font = MHFont(MHPxConvertPt(12.0f), NO);
    commentNumsLabel.textAlignment = NSTextAlignmentLeft;
    commentNumsLabel.textColor = MHGlobalOrangeTextColor;
    [titleView addSubview:commentNumsLabel];
    self.commentNumsLabel = commentNumsLabel;
    
    // 话题类型
    UIButton *topicTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topicTypeBtn addTarget:self action:@selector(_topicTypeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:topicTypeBtn];
    self.topicTypeBtn = topicTypeBtn;
    
    // 中间分割线
    MHDivider *middleLine = [MHDivider divider];
    self.middleLine = middleLine;
    [titleView addSubview:middleLine];
    
    // 话题热门
    [self.topicTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(self.titleView);
        make.width.equalTo(self.titleView.mas_height);
    }];
    
    // 评论数
    [self.commentNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel.mas_right).with.offset(6);
        make.right.equalTo(self.topicTypeBtn.mas_left);
        make.top.and.bottom.equalTo(self.titleView);
    }];
    
}


// 创建评论输入框
- (void) _setupCommentView
{
    // 评论View
    UIView *commentView = [[UIView alloc] init];
    commentView.backgroundColor = [UIColor whiteColor];
    self.commentView = commentView;
    [self.contentView addSubview:commentView];
    
    // 用户头像
    MHImageView *avatarView = [MHImageView imageView];
    avatarView.layer.cornerRadius = MHTopicAvatarWH*.5f;
    avatarView.layer.masksToBounds = YES;
    MHAccount *account =[AppDelegate sharedDelegate].account;
    if (MHObjectIsNil(account)) {
        avatarView.image = MHGlobalUserDefaultAvatar;
    }else{
        [MHWebImageTool setImageWithURL:account.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:avatarView];
    }
    self.avatarView = avatarView;
    [commentView addSubview:avatarView];
    
    // 评论按钮
    MHYouKuCommentButton *commentBtn = [MHYouKuCommentButton commentButton];
    self.commentBtn = commentBtn;
    [commentBtn addTarget:self action:@selector(_commentBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [commentBtn setTitleColor:MHColorFromHexString(@"#BEBEBE") forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage mh_resizedImage:@"comment_comment"] forState:UIControlStateNormal];
    [commentView addSubview:commentBtn];
    
    // 分割线
    MHDivider *bottomLine = [MHDivider divider];
    self.bottomLine = bottomLine;
    [commentView addSubview:bottomLine];
    
}



#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.contentView);
        make.height.mas_equalTo(50.0f);
    }];
    
    // 评论
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView.mas_left).with.offset(MHGlobalViewLeftInset);
        make.width.mas_equalTo([@"评论" mh_sizeWithFont:self.commentLabel.font].width+4);
        make.top.and.bottom.equalTo(self.titleView);
    }];
    
    
    // 中间分割线
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.titleView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
    
    
    // 布局
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentView.mas_left).with.offset(MHGlobalViewLeftInset);
        make.width.height.mas_equalTo(MHTopicAvatarWH);
        make.centerY.equalTo(self.commentView);
    }];
    
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(6);
        make.right.equalTo(self.commentView).with.offset(-1 * MHGlobalViewLeftInset);
        make.height.mas_equalTo(28.0f);
        make.centerY.equalTo(self.commentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.commentView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
}


#pragma mark - 事件处理
- (void)_topicTypeBtnDidClicked:(UIButton *)sender
{
    
}

- (void)_commentBtnDidClicked:(MHYouKuCommentButton *)sender
{
    // 评论按钮点击事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentHeaderViewForCommentBtnAction:)]) {
        [self.delegate commentHeaderViewForCommentBtnAction:self];
    }
}
@end

