//
//  MHYouKuTopicDetailController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuTopicDetailController.h"
#import "MHYouKuInputPanelView.h"
#import "MHTopicHeaderView.h"
#import "MHTopicFooterView.h"
#import "MHCommentCell.h"
#import "MHUserInfoController.h"
#import "MJRefresh.h"
#import "MHYouKuCommentButton.h"
#import "MHTopicManager.h"


@interface MHYouKuTopicDetailController ()<UITableViewDelegate , UITableViewDataSource , MHTopicHeaderViewDelegate , MHYouKuInputPanelViewDelegate , MHCommentCellDelegate>

/** commentView **/
@property (nonatomic , weak) UIView *commentView ;

/** tableView **/
@property (nonatomic , weak) UITableView *tableView;

/** 评论模型 */
@property (nonatomic , strong) NSMutableArray *commentFrames;

/** 输入面板 */
@property (nonatomic , weak) MHYouKuInputPanelView *inputPanelView ;

/** users */
@property (nonatomic , strong) NSMutableArray *users;

/** textString */
@property (nonatomic , copy) NSString *textString;

/** thumb */
@property (nonatomic , weak) UIButton *thumbBtn;

@end

@implementation MHYouKuTopicDetailController

- (void)dealloc
{
    MHDealloc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // fix:修改侧滑返回时 该界面的导航栏隐藏的bug 之前是写在_setup里面
    self.fd_prefersNavigationBarHidden = NO;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
    // 监听通知中心
    [self _addNotificationCenter];
    
    // 获取数据 假数据
    [self _setupData];
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter

- (NSMutableArray *)users
{
    if (_users == nil) {
        
        _users = [[NSMutableArray alloc] init];
        
        MHUser *user0 = [[MHUser alloc] init];
        user0.userId = @"1000";
        user0.nickname = @"CoderMikeHe";
        user0.avatarUrl = @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=1206211006,1884625258&fm=58";
        [_users addObject:user0];
        
        
        MHUser *user1 = [[MHUser alloc] init];
        user1.userId = @"1001";
        user1.nickname = @"吴亦凡";
        user1.avatarUrl = @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2625917416,3846475495&fm=58";
        [_users addObject:user1];
        
        
        MHUser *user2 = [[MHUser alloc] init];
        user2.userId = @"1002";
        user2.nickname = @"杨洋";
        user2.avatarUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=413353707,3948222604&fm=58";
        [_users addObject:user2];
        
        
        MHUser *user3 = [[MHUser alloc] init];
        user3.userId = @"1003";
        user3.nickname = @"陈伟霆";
        user3.avatarUrl = @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3937650650,3185640398&fm=58";
        [_users addObject:user3];
        
        
        MHUser *user4 = [[MHUser alloc] init];
        user4.userId = @"1004";
        user4.nickname = @"张艺兴";
        user4.avatarUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1691925636,1723246683&fm=58";
        [_users addObject:user4];
        
        
        MHUser *user5 = [[MHUser alloc] init];
        user5.userId = @"1005";
        user5.nickname = @"鹿晗";
        user5.avatarUrl = @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=437161406,3838120455&fm=58";
        [_users addObject:user5];
        
        
        MHUser *user6 = [[MHUser alloc] init];
        user6.userId = @"1006";
        user6.nickname = @"杨幂";
        user6.avatarUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1663450221,575161902&fm=58";
        [_users addObject:user6];
        
        
        MHUser *user7 = [[MHUser alloc] init];
        user7.userId = @"1007";
        user7.nickname = @"唐嫣";
        user7.avatarUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1655233011,1466773944&fm=58";
        [_users addObject:user7];
        
        
        MHUser *user8 = [[MHUser alloc] init];
        user8.userId = @"1008";
        user8.nickname = @"刘亦菲";
        user8.avatarUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3932899473,3078920054&fm=58";
        [_users addObject:user8];
        
        
        MHUser *user9 = [[MHUser alloc] init];
        user9.userId = @"1009";
        user9.nickname = @"林允儿";
        user9.avatarUrl = @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2961367360,923857578&fm=58";
        [_users addObject:user9];
        
    }
    return _users;
}

- (NSMutableArray *)commentFrames
{
    if (_commentFrames == nil) {
        _commentFrames = [[NSMutableArray alloc] init];
    }
    return _commentFrames;
}



#pragma mark - 初始化
- (void)_setup
{
    _textString = @"孤独之前是迷茫，孤独之后是成长；孤独没有不好，不接受孤独才不好；不合群是表面的孤独，合群了才是内心的孤独。那一天，在图书馆闲逛，书从中，这本书吸引了我，从那以后，睡前总会翻上几页。或许与初到一个陌生城市有关，或许因为近三十却未立而惆怅。孤独这个字眼对我而言，有着异常的吸引力。书中，作者以33段成长故事，描述了33种孤独，也带给了我们33次感怀。什么是孤独？孤独不仅仅是一个人，一间房，一张床。对未来迷茫，找不到前进的方向，是一种孤独；明知即将失去，徒留无奈，是一种孤独；回首来时的路，很多曾经在一起人与物，变得陌生而不识，这是一种孤独；即使心中很伤痛，却还笑着对身边人说，没事我很好，这也是一种孤独——第一次真正意识到，孤独与青春同在，与生活同在！孤独可怕吗？以前很害怕孤独，于是不断改变自己，去适应不同的人不同的事。却不曾想到，孤独也是需要去体验的。正如书中所说，孤独是你终将学会的相处方式。孤独，带给自己的是平静，是思考，而后是成长。于是开始懂得，去学会接受孤独，也接受内心中的自己，成长过程中的自己。我希望将来有一天，回首曾经过往时，可以对自己说，我的孤独，虽败犹荣！";
    
    self.fd_prefersNavigationBarHidden = NO;
    
}

#pragma mark -  假数据
- (void)_setupData
{
    NSInteger count = self.topicFrame.topic.commentsCount;
    NSMutableArray *comments = [NSMutableArray array];
    
    for (NSInteger j = 0; j < count; j++) {
        MHComment *comment = [[MHComment alloc] init];
        comment.commentId = [NSString stringWithFormat:@"%zd" , j];
        comment.creatTime = [NSDate mh_currentTimestamp];
        comment.text = [self.textString substringToIndex:[NSObject mh_randomNumber:1 to:60]];
        if (j%3==0) {
            MHUser *toUser = self.users[[NSObject mh_randomNumber:0 to:5]];
            comment.toUser = toUser;
        }
        MHUser *fromUser = self.users[[NSObject mh_randomNumber:6 to:9]];
        comment.fromUser = fromUser;
        [comments addObject:comment];
    }
    
    NSArray *newCommentFrames = [[MHTopicManager sharedManager] commentFramesWithComments:comments];
    
    // 将新数据插入到旧数据的最前面
    NSRange range = NSMakeRange(0, newCommentFrames.count);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self.commentFrames insertObjects:newCommentFrames atIndexes:indexSet];
    
    // 重新刷新表格
    [self.tableView reloadData];
    
    // 检测状态
    [self _checkFooterStateWithNewComments:newCommentFrames];
    
}




#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"全部回复";
}



#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建tableView
    [self _setupTableView];
    
    // 创建评论View
    [self _setupCommentView];
}

// 创建tableView
- (void)_setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(self.view);
    }];
    
    // 下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    header.automaticallyChangeAlpha = YES;
    tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    tableView.mj_footer = footer;
    
    
    // 获取模型
    MHTopicHeaderView *headerView = [MHTopicHeaderView topicHeaderView];
    headerView.delegate = self;
    headerView.topicFrame = self.topicFrame;
    headerView.mh_height = self.topicFrame.height;
    // header
    tableView.tableHeaderView = headerView;
    
    // 添加额外区域
    UIEdgeInsets insets = tableView.contentInset;
    insets.bottom = 55.0f;
    tableView.contentInset = insets;
    
}

// 创建评论输入框
- (void) _setupCommentView
{
    // 评论View
    UIView *commentView = [[UIView alloc] init];
    commentView.backgroundColor = [UIColor whiteColor];
    self.commentView = commentView;
    [self.view addSubview:commentView];
    
    MHAccount *account = [AppDelegate sharedDelegate].account;
    // 用户头像
    MHImageView *avatar = [MHImageView imageView];
    avatar.image = MHGlobalUserDefaultAvatar;
    if (!MHObjectIsNil(account)) {
        [MHWebImageTool setImageWithURL:account.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:avatar completed:^(UIImage * _Nullable image) {
            avatar.image = MHObjectIsNil(image)?MHGlobalUserDefaultAvatar.mh_circleImage:image.mh_circleImage;
        }];
    }
    
    [commentView addSubview:avatar];
    
    // 评论按钮
    MHYouKuCommentButton *commentBtn = [MHYouKuCommentButton commentButton];
    [commentBtn addTarget:self action:@selector(_commentBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitle:@"回复" forState:UIControlStateNormal];
    [commentBtn setTitleColor:MHColorFromHexString(@"#BEBEBE") forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage mh_resizedImage:@"comment_comment"] forState:UIControlStateNormal];
    [commentView addSubview:commentBtn];
    
    
    
    // 点赞
    UIButton *thumbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [thumbBtn addTarget:self action:@selector(_thumbBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [thumbBtn setImage:MHImageNamed(@"comment_zan_nor") forState:UIControlStateNormal];
    [thumbBtn setImage:MHImageNamed(@"comment_zan_high") forState:UIControlStateSelected];
    self.thumbBtn = thumbBtn;
    [commentView addSubview:thumbBtn];
    
    self.thumbBtn.selected = self.topicFrame.topic.isThumb;
    
    
    MHDivider *topLine = [MHDivider divider];
    [commentView addSubview:topLine];
    
    // 布局
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(55.0f);
    }];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentView.mas_left).with.offset(MHGlobalViewLeftInset);
        make.width.height.mas_equalTo(MHPxConvertPt(30.0f));
        make.centerY.equalTo(commentView);
    }];
    
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatar.mas_right).with.offset(MHGlobalViewLeftInset);
        make.right.equalTo(thumbBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(33.0f);
        make.centerY.equalTo(commentView);
    }];
    
    [thumbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(commentView);
        make.width.equalTo(commentView.mas_height);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(commentView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
}


#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{ 
}


#pragma mark - 请求数据

- (void)_loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_header endRefreshing];
        // 刷新数据
        [self.tableView reloadData];
    });
}

- (void)_loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.mj_footer endRefreshing];
        // 刷新数据
        [self.tableView reloadData];
    });
}


#pragma mark - 事件处理
- (void)_commentBtnDidClicked:(MHYouKuCommentButton *)sender
{
    // 评论跳转到评论
    MHCommentReply *commentReply =  [[MHTopicManager sharedManager] commentReplyWithModel:self.topicFrame.topic];
    // 回复
    [self _replyCommentWithCommentReply:commentReply];
}


- (void)_thumbBtnDidClicked:(UIButton *)sender
{
    // 评论
    [self _thumb];
}


#pragma mark - 辅助方法
- (void)_thumb
{
    // 点赞按钮被点击
    MHTopic *topic = self.topicFrame.topic;
    topic.thumb = !topic.isThumb;
    if (topic.isThumb) {
        topic.thumbNums+=1;
    }else{
        topic.thumbNums-=1;
    }
    
    
    self.thumbBtn.selected = topic.isThumb;
    
    // 刷新数据
    MHTopicHeaderView *headerView = (MHTopicHeaderView *)self.tableView.tableHeaderView;
    headerView.topicFrame = self.topicFrame;
    // 刷新数据
    [MHNotificationCenter postNotificationName:MHThumbSuccessNotification object:nil];
    
}


/** 评论回复 */
- (void)_replyCommentWithCommentReply:(MHCommentReply *)commentReply
{
    // 显示
    MHYouKuInputPanelView *inputPanelView = [MHYouKuInputPanelView inputPanelView];
    inputPanelView.commentReply = commentReply;
    inputPanelView.delegate = self;
    [inputPanelView show];
    
    self.inputPanelView = inputPanelView;
}


/**
 * 时刻监测footer的状态
 */
- (void)_checkFooterStateWithNewComments:(NSArray *)newComments
{
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.tableView.mj_footer.hidden = (self.commentFrames.count < MHCommentMaxCount);
    
    // 让底部控件结束刷新
    if (newComments.count < MHCommentMaxCount)
    {
        // 全部数据已经加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    } else {
        
        // 还没有加载完毕
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 这里判断刷新控件状态
    self.tableView.mj_footer.hidden = self.commentFrames.count<MHCommentMaxCount;
    
    return self.commentFrames.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCommentCell *cell = [MHCommentCell cellWithTableView:tableView];
    MHCommentFrame *commentFrame = self.commentFrames[indexPath.row];
    cell.commentFrame = commentFrame;
    cell.delegate = self;
    return cell;
}


- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCommentFrame *commentFrame = self.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCommentFrame *commentFrame = self.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中动画
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 评论 跳转到评论
    MHCommentFrame *commentFrame = self.commentFrames[indexPath.row];
    
    // 回复自己则跳过
    if ([commentFrame.comment.fromUser.userId isEqualToString:[AppDelegate sharedDelegate].account.userId]) {
        return;
    }
    
    // 评论跳转到评论
    MHCommentReply *commentReply =  [[MHTopicManager sharedManager] commentReplyWithModel:commentFrame.comment];
    
    // 显示
    [self _replyCommentWithCommentReply:commentReply];
}




#pragma mark - JLVideoInputPanelViewDelegate
- (void) inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText
{
    // show HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MHComment *comment = [[MHComment alloc] init];
        comment.mediabase_id = inputPanelView.commentReply.mediabase_id;
        comment.commentId = [NSString stringWithFormat:@"%zd",[NSObject mh_randomNumber:0 to:100]];
        comment.text = attributedText;
        comment.creatTime = [NSDate mh_currentTimestamp];
        
        MHUser *fromUser = [[MHUser alloc] init];
        fromUser.userId = [AppDelegate sharedDelegate].account.userId ;
        fromUser.avatarUrl = [AppDelegate sharedDelegate].account.avatarUrl;
        fromUser.nickname = [AppDelegate sharedDelegate].account.nickname;
        comment.fromUser = fromUser;
        
        
        // 只有回复才会有 toUser
        if (inputPanelView.commentReply.isReply) {
            MHUser *toUser = [[MHUser alloc] init];
            toUser.avatarUrl = inputPanelView.commentReply.user.avatarUrl;
            toUser.userId = inputPanelView.commentReply.user.userId;
            toUser.nickname = inputPanelView.commentReply.user.nickname;
            comment.toUser = toUser;
        }

        // 这里需要插入假数据
        NSArray *newcommentFrames = [[MHTopicManager sharedManager] commentFramesWithComments:@[comment]];
        // 将新数据插入到旧数据的最前面
        NSRange range = NSMakeRange(0, newcommentFrames.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.commentFrames insertObjects:newcommentFrames atIndexes:indexSet];
        
        // 重新刷新表格
        [self.tableView reloadData];
        
        // 检测状态
        [self _checkFooterStateWithNewComments:newcommentFrames];
        
        
        // 这里要插入话题数据源中去
        self.topicFrame.topic.commentsCount =  self.topicFrame.topic.commentsCount + 1;
        
        // 取出最后一条数据 就是查看全部xx条回复
        MHComment *lastComment = self.topicFrame.topic.comments.lastObject;
        lastComment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , self.topicFrame.topic.commentsCount];
        
        // 插入数据
        NSInteger count = self.topicFrame.commentFrames.count;
        NSInteger index = count - 1;
        
        [self.topicFrame.commentFrames insertObject:newcommentFrames.firstObject atIndex:index];
        [self.topicFrame.topic.comments insertObject:comment atIndex:index];
        
        // 通知发出去
        // 发送评论回复成功的通知
        [MHNotificationCenter postNotificationName:MHCommentReplySuccessNotification object:nil userInfo:@{MHCommentReplySuccessKey:self.topicFrame}];
        
    });
}

#pragma mark - MHCommentCellDelegate
- (void)commentCell:(MHCommentCell *)commentCell didClickedUser:(MHUser *)user
{
    MHUserInfoController *userInfo = [[MHUserInfoController alloc] init];
    userInfo.user = user;
    [self.navigationController pushViewController:userInfo animated:YES];
}

#pragma mark - MHTopicHeaderViewDelegate
- (void) topicHeaderViewDidClickedUser:(MHTopicHeaderView *)topicHeaderView
{
    MHUserInfoController *userInfo = [[MHUserInfoController alloc] init];
    userInfo.user = topicHeaderView.topicFrame.topic.user;
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void) topicHeaderViewForClickedMoreAction:(MHTopicHeaderView *)topicHeaderView
{
    /**
     * 这里点击事件自行根据自己UI处理
     *
     */
    MHLog(@"---点击更多按钮---");
    
}

- (void) topicHeaderViewForClickedThumbAction:(MHTopicHeaderView *)topicHeaderView
{
    /**
     * 这里点击事件自行根据自己UI处理
     *
     */
    MHLog(@"---点击👍按钮---");
    // 修改数据源方法
    [self _thumb];
    
    
}

// 话题内容点击
- (void) topicHeaderViewDidClickedTopicContent:(MHTopicHeaderView *)topicHeaderView
{
    // 评论跳转到评论
    MHCommentReply *commentReply =  [[MHTopicManager sharedManager] commentReplyWithModel:topicHeaderView.topicFrame.topic];
    
    // 回复
    [self _replyCommentWithCommentReply:commentReply];
}



@end
