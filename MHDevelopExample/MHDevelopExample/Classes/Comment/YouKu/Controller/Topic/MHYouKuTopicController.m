//
//  MHYouKuTopicController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuTopicController.h"
#import "MHTopicFrame.h"
#import "MHTopicHeaderView.h"
#import "MHTopicFooterView.h"
#import "MHCommentCell.h"
#import "MHUserInfoController.h"
#import "MJRefresh.h"
#import "MHYouKuCommentButton.h"
#import "MHYouKuCommentController.h"
#import "MHYouKuTopicDetailController.h"
#import "MHYouKuInputPanelView.h"
#import "MHTopicManager.h"
#import "MHYouKuCommentItem.h"
@interface MHYouKuTopicController ()<UITableViewDelegate,UITableViewDataSource , MHCommentCellDelegate ,MHTopicHeaderViewDelegate , MHYouKuInputPanelViewDelegate>

/** MHTopicFrame 模型 */
@property (nonatomic , strong) NSMutableArray *topicFrames;

/** UITableView */
@property (nonatomic , weak) UITableView *tableView ;

/** users */
@property (nonatomic , strong) NSMutableArray *users;

/** textString */
@property (nonatomic , copy) NSString *textString;

/** titleView*/
@property (nonatomic , weak) UIView *titleView;

/** commentView **/
@property (nonatomic , weak) UIView *commentView ;

/** 评论框按钮 */
@property (nonatomic , weak) MHYouKuCommentButton *commentBtn;

/** 选中的话题尺寸模型 */
@property (nonatomic , strong) MHTopicFrame *selectedTopicFrame;

/** 评论框 */
@property (nonatomic , weak) MHYouKuInputPanelView *inputPanelView;

@end

@implementation MHYouKuTopicController

- (void)dealloc
{
    MHDealloc;
    [MHNotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 初始化数据
    [self _setupData];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
    // 监听通知中心
    [self _addNotificationCenter];
    
}
#pragma mark - 公共方法
/** 刷新评论数 */
- (void) refreshCommentsWithCommentItem:(MHYouKuCommentItem *)commentItem
{
    // 刷新数据
    [self.commentBtn setTitle:[NSString stringWithFormat:@"已有%zd条评论，快来说说你的感想吧",commentItem.commentCount] forState:UIControlStateNormal];
}

#pragma mark - 私有方法
#pragma mark - Getter
- (NSMutableArray *)topicFrames
{
    if (_topicFrames == nil) {
        _topicFrames = [[NSMutableArray alloc] init];
    }
    return _topicFrames;
}

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


#pragma mark - 初始化
- (void)_setup
{
    _textString = @"孤独之前是迷茫，孤独之后是成长；孤独没有不好，不接受孤独才不好；不合群是表面的孤独，合群了才是内心的孤独。那一天，在图书馆闲逛，书从中，这本书吸引了我，从那以后，睡前总会翻上几页。或许与初到一个陌生城市有关，或许因为近三十却未立而惆怅。孤独这个字眼对我而言，有着异常的吸引力。书中，作者以33段成长故事，描述了33种孤独，也带给了我们33次感怀。什么是孤独？孤独不仅仅是一个人，一间房，一张床。对未来迷茫，找不到前进的方向，是一种孤独；明知即将失去，徒留无奈，是一种孤独；回首来时的路，很多曾经在一起人与物，变得陌生而不识，这是一种孤独；即使心中很伤痛，却还笑着对身边人说，没事我很好，这也是一种孤独——第一次真正意识到，孤独与青春同在，与生活同在！孤独可怕吗？以前很害怕孤独，于是不断改变自己，去适应不同的人不同的事。却不曾想到，孤独也是需要去体验的。正如书中所说，孤独是你终将学会的相处方式。孤独，带给自己的是平静，是思考，而后是成长。于是开始懂得，去学会接受孤独，也接受内心中的自己，成长过程中的自己。我希望将来有一天，回首曾经过往时，可以对自己说，我的孤独，虽败犹荣！";
}

#pragma mark -  初始化数据，假数据
- (void)_setupData
{
    
    NSDate *date = [NSDate date];
    
    // 初始化100条数据
    for (NSInteger i = 30; i>0; i--) {
        
        // 话题
        MHTopic *topic = [[MHTopic alloc] init];
        topic.topicId = [NSString stringWithFormat:@"%zd",i];
        topic.thumbNums = [NSObject mh_randomNumber:1000 to:100000];
        topic.thumb = [NSObject mh_randomNumber:0 to:1];
        
        // 构建时间假数据
        NSTimeInterval t = date.timeIntervalSince1970 - 1000 *(30-i) - 60;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:t];
        NSDateFormatter *formatter = [NSDateFormatter mh_defaultDateFormatter];
        NSString *creatTime = [formatter stringFromDate:d];
        topic.creatTime = creatTime;
        
        topic.text = [self.textString substringFromIndex:[NSObject mh_randomNumber:0 to:self.textString.length-1]];
        topic.user = self.users[[NSObject mh_randomNumber:0 to:9]];
        
        
        /** 
         * 服务器返回数据: 评论数据N条，但只会返回2条数据
         *
         */
        
        NSInteger commentsCount = [NSObject mh_randomNumber:0 to:20];
        topic.commentsCount = commentsCount;
        NSInteger count = commentsCount>2 ? 2 : commentsCount;
        for (NSInteger j = 0; j<count; j++) {
            MHComment *comment = [[MHComment alloc] init];
            comment.commentId = [NSString stringWithFormat:@"%zd%zd",i,j];
           
            comment.creatTime = [NSDate mh_currentTimestamp];
            comment.text = [self.textString substringToIndex:[NSObject mh_randomNumber:1 to:60]];
            if (j%3==0) {
                MHUser *toUser = self.users[[NSObject mh_randomNumber:0 to:5]];
                comment.toUser = toUser;
            }
            
            MHUser *fromUser = self.users[[NSObject mh_randomNumber:6 to:9]];
            comment.fromUser = fromUser;
            [topic.comments addObject:comment];
        }
        
        [self.topicFrames addObject:[self _topicFrameWithTopic:topic]];
    }
    
    // 检查刷新状态
    [self _checkFooterStateWithNewTopics:self.topicFrames];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 保证数据的唯一性
        [MHNotificationCenter postNotificationName:MHCommentRequestDataSuccessNotification object:nil userInfo:@{MHCommentRequestDataSuccessKey:self.topicFrames}];
    });
    
    
}





#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    //
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建titleView
    [self _setupTitleView];
    
    // 创建评论款
    [self _setupCommentView];
    
    // 创建tableView
    [self _setupTableView];
    
}

// 初始化评论View
- (void) _setupTitleView
{
    // 评论View
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    // 标注
    UIView *flagView = [[UIView alloc] init];
    flagView.backgroundColor = MHGlobalOrangeTextColor;
    [titleView addSubview:flagView];
    
    
    // 评论label
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.text = @"评论";
    commentLabel.font = MHFont(17.0f, NO);
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.textColor = MHGlobalBlackTextColor;
    [titleView addSubview:commentLabel];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:MHImageNamed(@"comment_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(_closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    
    MHDivider *bottomLine = [MHDivider divider];
    [titleView addSubview:bottomLine];
    
    // 布局
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(MHCommentHeaderViewHeight*.5f);
    }];
    
    // 布局flagView
    [flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(16.0f);
        make.centerY.equalTo(self.titleView);
    }];
    
    
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(MHGlobalViewLeftInset);
        make.width.mas_equalTo(100);
        make.top.and.bottom.equalTo(titleView);
    }];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(titleView);
        make.width.equalTo(titleView.mas_height);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(titleView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
}


// 创建评论输入框
- (void) _setupCommentView
{
    // 评论View
    UIView *commentView = [[UIView alloc] init];
    commentView.backgroundColor = [UIColor whiteColor];
    self.commentView = commentView;
    [self.view addSubview:commentView];
    
    // 用户头像
    MHImageView *avatar = [MHImageView imageView];
    avatar.image = MHGlobalUserDefaultAvatar;
    MHAccount *account = [AppDelegate sharedDelegate].account;
    if (!MHObjectIsNil(account)) {
        [MHWebImageTool setImageWithURL:account.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:avatar completed:^(UIImage * _Nullable image) {
            
            avatar.image = MHObjectIsNil(image)?MHGlobalUserDefaultAvatar.mh_circleImage:image.mh_circleImage;
            
        }];
    }
    
    
    [commentView addSubview:avatar];
    
    // 评论按钮
    MHYouKuCommentButton *commentBtn = [[MHYouKuCommentButton alloc] init];
    [commentBtn addTarget:self action:@selector(_commentBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setTitleColor:MHColorFromHexString(@"#BEBEBE") forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage mh_resizedImage:@"comment_comment"] forState:UIControlStateNormal];
    self.commentBtn = commentBtn;
    [commentView addSubview:commentBtn];
    
    
    
    // 话题类型
    UIButton *topicTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topicTypeBtn setImage:MHImageNamed(@"MainTagSubIcon") forState:UIControlStateNormal];
    [topicTypeBtn setImage:MHImageNamed(@"MainTagSubIconClick") forState:UIControlStateSelected];
    [topicTypeBtn addTarget:self action:@selector(_topicTypeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [commentView addSubview:topicTypeBtn];
    
    MHDivider *bottomLine = [MHDivider divider];
    [commentView addSubview:bottomLine];
    
    // 布局
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(MHCommentHeaderViewHeight*.5f);
    }];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentView.mas_left).with.offset(MHGlobalViewLeftInset);
        make.width.height.mas_equalTo(MHPxConvertPt(30.0f));
        make.centerY.equalTo(commentView);
    }];
    
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatar.mas_right).with.offset(MHGlobalViewLeftInset);
        make.right.equalTo(topicTypeBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(28.0f);
        make.centerY.equalTo(commentView);
    }];
    
    [topicTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(commentView);
        make.width.equalTo(commentView.mas_height);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(commentView);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
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
        make.left.bottom.and.right.equalTo(self.view);
        make.top.equalTo(self.commentView.mas_bottom);
    }];
    
    // 下拉刷新控件
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

#pragma mark - 加载数据
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


#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 视频评论成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentSuccess:) name:MHCommentSuccessNotification object:nil];
    
    // 视频评论回复成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentReplySuccess:) name:MHCommentReplySuccessNotification object:nil];
    
    // 视频点赞成功
    [MHNotificationCenter addObserver:self selector:@selector(_thumbSuccess:) name:MHThumbSuccessNotification object:nil];
}


#pragma mark - 通知事件处理
// 评论视频成功
- (void)_commentSuccess:(NSNotification *)note
{
    MHTopicFrame *topicFrame = [note.userInfo objectForKey:MHCommentSuccessKey];
    
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    // 插入数据
    [self.topicFrames insertObject:topicFrame atIndex:0];
    // 刷新数据
    [self.tableView reloadData];
}

// 视频回复成功
- (void)_commentReplySuccess:(NSNotification *)note
{
    MHTopicFrame *topicFrame = [note.userInfo objectForKey:MHCommentReplySuccessKey];
    
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    if (topicFrame == self.selectedTopicFrame) {
        // 刷新组
        [self _reloadSelectedSectin];
        
    }else
    {   // 刷新
        [self.tableView reloadData];
    }

}

// 话题点赞成功
- (void)_thumbSuccess:(NSNotificationCenter *)note
{
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - 点击事件处理
- (void)_closeBtnDidClicked:(UIButton *)sender
{
    // 关闭按钮被点击
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicControllerForCloseAction:)]) {
        [self.delegate topicControllerForCloseAction:self];
    }
}

- (void)_commentBtnDidClicked:(MHYouKuCommentButton *)sender
{
    // 评论框按钮被点击
    MHYouKuCommentController *comment = [[MHYouKuCommentController alloc] init];
    comment.mediabase_id = self.mediabase_id;
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:comment];
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
}

- (void)_topicTypeBtnDidClicked:(UIButton *)sender
{
    // 筛选条件按钮被点击
    // 弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // action
    UIAlertAction *latest = [UIAlertAction actionWithTitle:@"最新评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        sender.selected = NO;
        
    }];
    
    
    UIAlertAction *hottest = [UIAlertAction actionWithTitle:@"最热评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        sender.selected = YES;
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alertController addAction:latest];
    [alertController addAction:hottest];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 辅助方法
/** topic --- topicFrame */
- (MHTopicFrame *)_topicFrameWithTopic:(MHTopic *)topic
{
    // 这里要判断评论个数大于2 显示全部评论数
    if (topic.commentsCount>2) {
        // 设置假数据
        MHComment *comment = [[MHComment alloc] init];
        comment.commentId = MHAllCommentsId;
        comment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , topic.commentsCount];
        // 添加假数据
        [topic.comments addObject:comment];
    }
    
    MHTopicFrame *topicFrame = [[MHTopicFrame alloc] init];
    // 传递话题模型数据，计算所有子控件的frame
    topicFrame.topic = topic;
    return topicFrame;
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

/** 刷新选中行 */
- (void) _reloadSelectedSectin
{
    // 获取索引
    [self.tableView beginUpdates];
    NSInteger index = [self.topicFrames indexOfObject:self.selectedTopicFrame];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

/**
 * 时刻监测footer的状态
 */
- (void)_checkFooterStateWithNewTopics:(NSArray *)newTopics
{
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.tableView.mj_footer.hidden = (self.topicFrames.count < MHCommentMaxCount);
    // 让底部控件结束刷新
    if (newTopics.count < MHCommentMaxCount)
    {
        // 全部数据已经加载完毕
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    } else {
        
        // 还没有加载完毕
        [self.tableView.mj_footer endRefreshing];
    }
}





#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.topicFrames.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 这里判断刷新控件状态
    self.tableView.mj_footer.hidden = self.topicFrames.count<MHCommentMaxCount;
    
    MHTopicFrame *topicFrame = self.topicFrames[section];
    return topicFrame.commentFrames.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCommentCell *cell = [MHCommentCell cellWithTableView:tableView];
    MHTopicFrame *topicFrame = self.topicFrames[indexPath.section];
    MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
    cell.commentFrame = commentFrame;
    cell.delegate = self;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MHTopicHeaderView *headerView = [MHTopicHeaderView headerViewWithTableView:tableView];
    MHTopicFrame *topicFrame = self.topicFrames[section];
    headerView.topicFrame = topicFrame;
    headerView.delegate = self;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MHTopicFooterView *footerView = [MHTopicFooterView footerViewWithTableView:tableView];
    [footerView setSection:section allSections:self.topicFrames.count];
    return footerView;
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHTopicFrame *topicFrame = self.topicFrames[indexPath.section];
    MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MHTopicFrame *topicFrame = self.topicFrames[section];
    return topicFrame.height;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MHTopicFrame *topicFrame = self.topicFrames[section];
    return topicFrame.commentFrames.count>0? MHTopicVerticalSpace:MHGlobalBottomLineHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 取出数据
    MHTopicFrame *topicFrame = self.topicFrames[indexPath.section];
    MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
    // 选中的栏
    self.selectedTopicFrame = topicFrame;
    
    
    // 判断
    if ([commentFrame.comment.commentId isEqualToString:MHAllCommentsId]) {
        // 跳转到更多评论
        MHYouKuTopicDetailController *topicDetail = [[MHYouKuTopicDetailController alloc] init];
        topicDetail.topicFrame = topicFrame;
        // push
        [self.parentViewController.navigationController pushViewController:topicDetail animated:YES];
        return;
    }
    
    // 这里是回复

    // 回复自己则跳过
    if ([commentFrame.comment.fromUser.userId isEqualToString:[AppDelegate sharedDelegate].account.userId]) {
        return;
    }
    
    // 回复评论
    MHCommentReply *commentReply = [[MHTopicManager sharedManager] commentReplyWithModel:commentFrame.comment];
    
    // show
    [self _replyCommentWithCommentReply:commentReply];

    
}

#pragma mark - MHYouKuInputPanelViewDelegate
- (void) inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText
{
    // 发送评论 模拟网络发送
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 评论或者回复成功
        MHComment *comment = [[MHComment alloc] init];
        comment.mediabase_id = self.mediabase_id;
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
        MHCommentFrame* newCommentFrame = [[MHTopicManager sharedManager] commentFramesWithComments:@[comment]].lastObject;
        
        // 这里要插入话题数据源中去
        
        // 修改评论回复数目
        self.selectedTopicFrame.topic.commentsCount  =  self.selectedTopicFrame.topic.commentsCount + 1;
        
        // 判断数据
        if (self.selectedTopicFrame.topic.comments.count>2) {
            
            // 有 查看全部xx条回复
            // 插入数据
            NSInteger count = self.selectedTopicFrame.commentFrames.count;
            NSInteger index = count - 1;
            [self.selectedTopicFrame.commentFrames insertObject:newCommentFrame atIndex:index];
            [self.selectedTopicFrame.topic.comments insertObject:comment atIndex:index];
            
            // 取出最后一条数据 就是查看全部xx条回复
            MHComment *lastComment = self.selectedTopicFrame.topic.comments.lastObject;
            lastComment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , self.selectedTopicFrame.topic.commentsCount];
            
        }else {
            
            // 临界点
            if (self.selectedTopicFrame.topic.comments.count == 2)
            {
                // 添加数据源
                [self.selectedTopicFrame.commentFrames addObject:newCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:comment];
                
                // 设置假数据
                MHComment *lastComment = [[MHComment alloc] init];
                lastComment.commentId = MHAllCommentsId;
                lastComment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , self.selectedTopicFrame.topic.commentsCount];
                MHCommentFrame *lastCommentFrame =  [[MHTopicManager sharedManager] commentFramesWithComments:@[lastComment]].lastObject;
                // 添加假数据
                [self.selectedTopicFrame.commentFrames addObject:lastCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:lastComment];
            }else{
                // 添加数据源
                [self.selectedTopicFrame.commentFrames addObject:newCommentFrame];
                [self.selectedTopicFrame.topic.comments addObject:comment];
            }
        }
        
        // 发送评论回复成功的通知
        [MHNotificationCenter postNotificationName:MHCommentReplySuccessNotification object:nil userInfo:@{MHCommentReplySuccessKey:self.selectedTopicFrame}];
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
    MHTopic *topic = topicHeaderView.topicFrame.topic;
    topic.thumb = !topic.isThumb;
    if (topic.isThumb) {
        topic.thumbNums+=1;
    }else{
        topic.thumbNums-=1;
    }
    
    // 刷新数据
    [MHNotificationCenter postNotificationName:MHThumbSuccessNotification object:nil];
    
}

// 话题内容点击
- (void) topicHeaderViewDidClickedTopicContent:(MHTopicHeaderView *)topicHeaderView
{
    // 选中的栏 话题内容自己可以评论
    self.selectedTopicFrame = topicHeaderView.topicFrame;
    
    // 评论跳转到评论
    MHCommentReply *commentReply =  [[MHTopicManager sharedManager] commentReplyWithModel:topicHeaderView.topicFrame.topic];
    
    // 回复
    [self _replyCommentWithCommentReply:commentReply];
}




@end
