//
//  MHTopicHeaderView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicHeaderView.h"
#import "MHTopicFrame.h"


@interface MHTopicHeaderView ()

/** 头像 */
@property (nonatomic , weak) MHImageView *avatarView;

/** 昵称 */
@property (nonatomic , weak) YYLabel *nicknameLable;

/** 点赞 */
@property (nonatomic , weak) UIButton *thumbBtn;

/** 更多 */
@property (nonatomic , weak) UIButton *moreBtn;

/** 创建时间 */
@property (nonatomic , weak) YYLabel *createTimeLabel;

/** ContentView */
@property (nonatomic , weak) UIView *contentBaseView;

/** 文本内容 */
@property (nonatomic , weak) YYLabel *contentLabel;


@end


@implementation MHTopicHeaderView

+ (instancetype)topicHeaderView
{
    return [[self alloc] init];
}

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TopicHeader";
    MHTopicHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        MHLog(@"....创建表头...");
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
#pragma mark - Setter
- (void)setTopicFrame:(MHTopicFrame *)topicFrame
{
    _topicFrame = topicFrame;
    
    MHTopic *topic = topicFrame.topic;
    MHUser *user = topic.user;
    
    // 头像
    self.avatarView.frame = topicFrame.avatarFrame;
    [MHWebImageTool setImageWithURL:user.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:self.avatarView];
    
    // 昵称
    self.nicknameLable.frame = topicFrame.nicknameFrame;
    self.nicknameLable.text = user.nickname;
    
    // 点赞
    self.thumbBtn.frame = topicFrame.thumbFrame;
    [self.thumbBtn setTitle:topic.thumbNumsString forState:UIControlStateNormal];
    self.thumbBtn.selected = topic.isThumb;
    
    // 更多
    self.moreBtn.frame = topicFrame.moreFrame;
    
    // 时间
    self.createTimeLabel.frame = topicFrame.createTimeFrame;
    self.createTimeLabel.text = topic.creatTime;
    
    // 内容
    self.contentLabel.frame = topicFrame.textFrame;
    self.contentLabel.attributedText = topic.attributedText;
    
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 头像
    MHImageView *avatarView = [MHImageView imageView];
    
    avatarView.layer.cornerRadius = MHTopicAvatarWH*.5f;
    // 这样写比较消耗性能
    avatarView.layer.masksToBounds = YES;
    
    self.avatarView = avatarView;
    [self.contentView addSubview:avatarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_avatarOrNicknameDidClicked)];
    [avatarView addGestureRecognizer:tap];
    
    
    // 昵称
    YYLabel *nicknameLable = [[YYLabel alloc] init];
    nicknameLable.text = @"";
    nicknameLable.font = MHTopicNicknameFont;
    nicknameLable.textAlignment = NSTextAlignmentLeft;
    nicknameLable.textColor = MHGlobalGrayTextColor;
    [self.contentView addSubview:nicknameLable];
    self.nicknameLable = nicknameLable;
    
    __weak typeof(self) weakSelf = self;
    nicknameLable.textTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf _avatarOrNicknameDidClicked];
    };
    
    // 点赞按钮
    UIButton *thumbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thumbBtn.adjustsImageWhenHighlighted = NO;
    [thumbBtn setImage:MHImageNamed(@"comment_zan_nor") forState:UIControlStateNormal];
    [thumbBtn setImage:MHImageNamed(@"comment_zan_high") forState:UIControlStateSelected];
    [thumbBtn setTitleColor:MHGlobalGrayTextColor forState:UIControlStateNormal];
    [thumbBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [thumbBtn addTarget:self action:@selector(_thumbBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    thumbBtn.titleLabel.font = MHTopicThumbFont;
    [self.contentView addSubview:thumbBtn];
    self.thumbBtn = thumbBtn;
    
    
    // 更多
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:MHImageNamed(@"comment_more") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(_moreBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    
    // 时间
    YYLabel *createTimeLabel = [[YYLabel alloc] init];
    createTimeLabel.text = @"";
    createTimeLabel.font = MHTopicNicknameFont;
    createTimeLabel.textAlignment = NSTextAlignmentLeft;
    createTimeLabel.textColor = MHGlobalGrayTextColor;
    [self.contentView addSubview:createTimeLabel];
    self.createTimeLabel = createTimeLabel;
    createTimeLabel.textTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf _contentTextDidClicked];
    };
    
    
    // 文本
    YYLabel *contentLabel = [[YYLabel alloc] init];
    // 设置文本的额外区域，修复用户点击文本没有效果
    UIEdgeInsets textContainerInset = contentLabel.textContainerInset;
    textContainerInset.top = MHTopicVerticalSpace;
    textContainerInset.bottom = MHTopicVerticalSpace;
    contentLabel.textContainerInset = textContainerInset;
    
    contentLabel.numberOfLines = 0 ;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    contentLabel.textTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [weakSelf _contentTextDidClicked];
    };
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    
}

#pragma mark - 事件处理

- (void)_thumbBtnDidClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicHeaderViewForClickedThumbAction:)]) {
        [self.delegate topicHeaderViewForClickedThumbAction:self];
    }
    
}

- (void)_moreBtnDidClicked:(UIButton *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicHeaderViewForClickedMoreAction:)]) {
        [self.delegate topicHeaderViewForClickedMoreAction:self];
    }
}

- (void)_avatarOrNicknameDidClicked
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(topicHeaderViewDidClickedUser:)]) {
        [self.delegate topicHeaderViewDidClickedUser:self];
    }
}

- (void)_contentTextDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicHeaderViewDidClickedTopicContent:)]) {
        [self.delegate topicHeaderViewDidClickedTopicContent:self];
    }
}

@end
