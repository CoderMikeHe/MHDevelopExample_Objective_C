//
//  MHTopicCell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicCell.h"
#import "MHTopicFrame.h"
#import "MHTopicCommentCell.h"

@interface MHTopicCell()< UITableViewDelegate , UITableViewDataSource,MHTopicCommentCellDelegate >

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

/** UITableView */
@property (nonatomic , weak) UITableView *tableView;

/** 分割线 */
@property (nonatomic , weak) MHDivider *divider;

@end


@implementation MHTopicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TopicCell";
    MHTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        MHLog(@"....cell嵌套tableView.....创建话题cell...");
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    self.thumbBtn.enabled = !topic.isThumb;
    
    // 更多
    self.moreBtn.frame = topicFrame.moreFrame;
    
    // 时间
    self.createTimeLabel.frame = topicFrame.createTimeFrame;
    self.createTimeLabel.text = topic.creatTime;
    
    // 内容
    self.contentLabel.frame = topicFrame.textFrame;
    self.contentLabel.attributedText = topic.attributedText;
    
    // 刷新评论tableView
    self.tableView.frame = topicFrame.tableViewFrame;
    [self.tableView reloadData];
    
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
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
    [thumbBtn setImage:MHImageNamed(@"comment_zan_high") forState:UIControlStateDisabled];
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

    // UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.scrollEnabled = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    
    // 分割线
    MHDivider *divider = [MHDivider divider];
    self.divider = divider;
    [self.contentView addSubview:divider];
 
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    
}


#pragma mark - override


#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    self.divider.frame = CGRectMake(0, self.mh_height-MHGlobalBottomLineHeight, self.mh_width, MHGlobalBottomLineHeight);
    
}


#pragma mark - 事件处理

- (void)_thumbBtnDidClicked:(UIButton *)sender
{
    sender.enabled = NO;
    self.topicFrame.topic.thumb = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCellForClickedThumbAction:)]) {
        [self.delegate topicCellForClickedThumbAction:self];
    }

}

- (void)_moreBtnDidClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCellForClickedMoreAction:)]) {
        [self.delegate topicCellForClickedMoreAction:self];
    }
}

- (void)_avatarOrNicknameDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCellDidClickedUser:)]) {
        [self.delegate topicCellDidClickedUser:self];
    }
}


- (void)_contentTextDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCellDidClickedTopicContent:)]) {
        [self.delegate topicCellDidClickedTopicContent:self];
    }
}


#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicFrame.commentFrames.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHTopicCommentCell *cell = [MHTopicCommentCell cellWithTableView:tableView];
    MHCommentFrame *commentFrame = self.topicFrame.commentFrames[indexPath.row];
    cell.commentFrame = commentFrame;
    cell.delegate = self;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCommentFrame *commentFrame = self.topicFrame.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCell:didSelectRowAtIndexPath:)]) {
        [self.delegate topicCell:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - MHTopicCommentCellDelegate
- (void) topicCommentCell:(MHTopicCommentCell *)topicCommentCell didClickedUser:(MHUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicCell:didClickedUser:)]) {
        [self.delegate topicCell:self didClickedUser:user];
    }
}

@end
