//
//  MHYouKuController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuController.h"
#import "MHTopicFrame.h"
#import "MHTopicHeaderView.h"
#import "MHTopicFooterView.h"
#import "MHCommentCell.h"
#import "MHUserInfoController.h"
#import "MHYouKuBottomToolBar.h"
#import "MHYouKuTopicController.h"
#import "MHYouKuMedia.h"
#import "MHYouKuMediaSummary.h"
#import "MHYouKuMediaDetail.h"
#import "MHYouKuCommentItem.h"
#import "MHTopicManager.h"
#import "MHUserInfoController.h"
#import "MHYouKuAnthologyItem.h"
#import "MHYouKuAnthologyHeaderView.h"
#import "MHYouKuCommentHeaderView.h"
#import "MHYouKuCommentController.h"
#import "MHYouKuInputPanelView.h"
#import "MHYouKuTopicDetailController.h"

@interface MHYouKuController ()<UITableViewDelegate,UITableViewDataSource , MHCommentCellDelegate ,MHTopicHeaderViewDelegate,MHYouKuBottomToolBarDelegate,MHYouKuTopicControllerDelegate,MHYouKuAnthologyHeaderViewDelegate,MHYouKuCommentHeaderViewDelegate , MHYouKuInputPanelViewDelegate>

/** 顶部容器View   **/
@property (nonatomic , strong) UIView *topContainer;

/** 底部容器View  **/
@property (nonatomic , strong) UIView *bottomContainer;

/** 话题控制器的容器View */
@property (nonatomic , strong) UIView *topicContainer;

/** Footer */
@property (nonatomic , strong) UIButton *commentFooter;

/** 返回按钮 **/
@property (nonatomic , strong) MHBackButton *backBtn;

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** 视频toolBar **/
@property (nonatomic , weak) MHYouKuBottomToolBar *bottomToolBar;

/** 话题控制器 **/
@property (nonatomic , weak) MHYouKuTopicController *topic;

/** dataSource */
@property (nonatomic , strong) NSMutableArray *dataSource;

/**  */
@property (nonatomic , strong) MHYouKuMedia *media;


/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 简介 */
@property (nonatomic , weak) MHYouKuMediaSummary *summary ;
/** 详情 **/
@property (nonatomic , weak) MHYouKuMediaDetail *detail;

/** 选中的话题尺寸模型 */
@property (nonatomic , strong) MHTopicFrame *selectedTopicFrame;

/** 评论Item */
@property (nonatomic , strong) MHYouKuCommentItem *commentItem;
/** 选集Item */
@property (nonatomic , strong) MHYouKuAnthologyItem *anthologyItem;

/** 选集 */
@property (nonatomic , weak) MHYouKuAnthologyHeaderView *anthologyHeaderView;

/** inputPanelView */
@property (nonatomic , weak) MHYouKuInputPanelView *inputPanelView;

@end

@implementation MHYouKuController

- (void)dealloc
{
    MHDealloc;
    // 移除通知
    [MHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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
    
    // 初始化假数据
    [self _setupData];
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (UIView *)topContainer
{
    if (_topContainer == nil) {
        _topContainer = [[UIView alloc] init];
        _topContainer.backgroundColor = [UIColor blackColor];
    }
    return _topContainer;
}

- (UIView *)bottomContainer
{
    if (_bottomContainer == nil) {
        _bottomContainer = [[UIView alloc] init];
        _bottomContainer.backgroundColor = [UIColor redColor];
    }
    return _bottomContainer;
}

// 返回按钮
- (MHBackButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[MHBackButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"player_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(_backBtnDidiClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeCenter;
    }
    return _backBtn;
}


- (UIView *)topicContainer
{
    if (_topicContainer == nil) {
        _topicContainer = [[UIView alloc] init];
        _topicContainer.backgroundColor = [UIColor whiteColor];
    }
    return _topicContainer;
}

- (MHYouKuMedia *)media
{
    if (_media == nil) {
        _media = [[MHYouKuMedia alloc] init];
        _media.thumb = [NSObject mh_randomNumber:0 to:1];
        _media.thumbNums = [NSObject mh_randomNumber:10 to:1000];
        _media.mediaUrl = @"xxxx";
        _media.commentNums = [NSObject mh_randomNumber:0 to:1000];
        _media.collect = [NSObject mh_randomNumber:0 to:1];
        _media.mediaScanTotal = [NSObject mh_randomNumber:0 to:100000];
        _media.creatTime = [NSDate mh_currentTimestamp];
    }
    return _media;
}

- (MHYouKuCommentItem *)commentItem
{
    if (_commentItem == nil) {
        _commentItem = [[MHYouKuCommentItem alloc] init];
        _commentItem.title = @"评论";
        _commentItem.commentCount = 0;
    }
    return _commentItem;
}

- (MHYouKuAnthologyItem *)anthologyItem
{
    if (_anthologyItem == nil) {
        _anthologyItem = [[MHYouKuAnthologyItem alloc] init];
        _anthologyItem.title = @"选集";
        _anthologyItem.mediabase_id = self.mediabase_id;
        _anthologyItem.displayType = MHYouKuAnthologyDisplayTypeTextPlain;
        // 98757
        for (NSInteger i = 89750; i<89800; i++) {
            
            MHYouKuAnthology *anthology = [[MHYouKuAnthology alloc] init];
            anthology.albums_sort = (i-89749);
            anthology.mediabase_id = [NSString stringWithFormat:@"%zd",i];
            if([anthology.mediabase_id isEqualToString:_anthologyItem.mediabase_id])
            {
                _anthologyItem.item = (i-89750);
            }
            [_anthologyItem.anthologys addObject:anthology];
        }
    }
    return _anthologyItem;
}


/** 评论底部 */
- (UIButton *)commentFooter
{
    if (_commentFooter == nil) {
        _commentFooter = [[UIButton alloc] init];
        _commentFooter.backgroundColor = [UIColor whiteColor];
        [_commentFooter addTarget:self action:@selector(_commentFooterDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_commentFooter setTitle:@"查看全部0条回复 >" forState:UIControlStateNormal];
        _commentFooter.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        [_commentFooter setTitleColor:MHGlobalOrangeTextColor forState:UIControlStateNormal];
        [_commentFooter setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateHighlighted];
        _commentFooter.mh_height = 44.0f;
    }
    return _commentFooter;
}


#pragma mark - 初始化
- (void)_setup
{
    // 当前控制器 禁止侧滑 返回
    self.fd_interactivePopDisabled = YES;
    // hiden掉系统的导航栏
    self.fd_prefersNavigationBarHidden = YES;
    // 设置视频id 编号89757
    _mediabase_id = @"89757";
   
}

#pragma mark -  初始化数据

- (void)_setupData
{
    [self.dataSource insertObject:self.anthologyItem atIndex:0];
    
    [self.tableView reloadData];
}



#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"仿优酷视频的评论回复";
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建黑色状态条
    [self _setupStatusBarView];
    
    // 创建顶部View
    [self _setupTopContainerView];
    
    // 创建底部View
    [self _setupBottomContainerView];
    
    // 刷新数据
    [self _refreshDataWithMedia:self.media];
}

// 创建statusBarView
- (void)_setupStatusBarView
{
    UIView *statusBarView =  [[UIView alloc] init];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
    [statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(20.0f);
    }];
    
    // 创建视图view
    [self _setupVideoBackgroundView];
    
    // 创建返回按钮
    [self _setupBackButton];
}

// 初始化播放器View
- (void)_setupTopContainerView
{
    [self.view addSubview:self.topContainer];
    [self.topContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.topContainer.mas_width).multipliedBy(9.0f/16.0f);
    }];
}



// 创建视频封面
- (void)_setupVideoBackgroundView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = MHImageNamed(@"comment_loading_bgView");
    [self.topContainer addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

// 创建返回按钮
- (void)_setupBackButton
{
    [self.topContainer addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainer.mas_left).offset(20);
        make.top.equalTo(self.topContainer).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
}


// 底部View
- (void)_setupBottomContainerView
{
    // 添加底部容器
    [self.view addSubview:self.bottomContainer];
    
    // 布局
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainer.mas_bottom);
        make.left.bottom.and.right.equalTo(self.view);
    }];
    
    // 创建底部工具条
    [self _setupBottomToolBar];
    
    // 创建tableView
    [self _setupTableView];
    
    // 创建容器
    [self _setupTopicContainer];
    
    // 创建详情
    [self _setupVideoDetail];
    
}

// 创建底部工具条
- (void)_setupBottomToolBar
{
    // 底部工具条
    MHYouKuBottomToolBar *bottomToolBar = [[MHYouKuBottomToolBar alloc] init];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    bottomToolBar.delegate = self;
    self.bottomToolBar = bottomToolBar;
    [self.bottomContainer addSubview:bottomToolBar];
    
    // 布局工具条
    [bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.bottomContainer);
        make.height.mas_equalTo(36.0f);
    }];
    
    
}


// 初始化话题容器
- (void)_setupTopicContainer
{
    // 容器
    [self.bottomContainer addSubview:self.topicContainer];
    
    // 话题控制器
    MHYouKuTopicController *topic = [[MHYouKuTopicController alloc] init];
    topic.mediabase_id = self.mediabase_id;
    topic.delegate = self;
    [self.topicContainer addSubview:topic.view];
    [self addChildViewController:topic];
    [topic didMoveToParentViewController:self];
    self.topic = topic;
    
    //
    [self.topicContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.bottomContainer);
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.height.mas_equalTo(self.bottomContainer.mas_height);
    }];
    
    // 布局
    [topic.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}


// 创建tableView
- (void)_setupTableView
{
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.bottomContainer addSubview:tableView];
    self.tableView = tableView;
    // 布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomToolBar.mas_bottom);
        make.left.bottom.and.right.equalTo(self.bottomContainer);
    }];
    
    // 视频简介 tableViewHeader
    MHYouKuMediaSummary *summary = [MHYouKuMediaSummary summary];
    summary.backgroundColor = [UIColor whiteColor];
    self.summary = summary;
    summary.mh_height = 70.0f;
    tableView.tableHeaderView = summary;
    
    // 详情点击事件
    __weak typeof(self) weakSelf = self;
    [summary setDetailCallBack:^(MHYouKuMediaSummary *s) {
        //
        [weakSelf _showMediaDetail];
    }];
    
    
    
}


/** 创建视频详情 */
- (void)_setupVideoDetail
{
    // 详情点击事件
    __weak typeof(self) weakSelf = self;
    // 视频详情
    MHYouKuMediaDetail *detail =  [[MHYouKuMediaDetail alloc] init];
    self.detail = detail;
    detail.backgroundColor = [UIColor whiteColor];
    [self.bottomContainer addSubview:detail];
    
    // 布局视频详情
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(self.bottomContainer.mas_height);
    }];
    
    // 事件
    [detail setCloseCallBack:^(MHYouKuMediaDetail *detail) {
        
        [weakSelf _hideMediaDetail];
    }];
    
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 视频评论成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentSuccess:) name:MHCommentSuccessNotification object:nil];
    
    // 视频评论回复成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentReplySuccess:) name:MHCommentReplySuccessNotification object:nil];
    
    // 请求数据成功
    [MHNotificationCenter addObserver:self selector:@selector(_commentRequestDataSuccess:) name:MHCommentRequestDataSuccessNotification object:nil];
    
    // 视频点赞成功
    [MHNotificationCenter addObserver:self selector:@selector(_thumbSuccess:) name:MHThumbSuccessNotification object:nil];
}

#pragma mark - 通知事件处理
// 视频评论成功
- (void)_commentSuccess:(NSNotification *)note
{
    // 获取数据
    MHTopicFrame *topicFrame = [note.userInfo objectForKey:MHCommentSuccessKey];
    
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    // 修改数据
    self.media.commentNums = self.media.commentNums+1;

    // 存在评论容器
    if ([self.dataSource containsObject:self.commentItem])
    {
        // 获取索引 可能这里需要加锁  防止插入数据异常
        NSInteger index = [self.dataSource indexOfObject:self.commentItem];
        // 安全处理
        if (self.dataSource.count == (index+1)) {
            // 直接添加到后面
            [self.dataSource addObject:topicFrame];
        }else{
            // 插入数据
            [self.dataSource insertObject:topicFrame atIndex:(index+1)];
        }
    }else{
        
        // 不存在评论容器  就添加一个
        
        // 配置一个评论表头的假数据
        [self.dataSource addObject:self.commentItem];
        // 配置评论数据
        [self.dataSource addObject:topicFrame];
    }
    
    // 检测footer
    [self _checkTableViewFooterState:YES];
    
    // 刷新数据
    [self _refreshDataWithMedia:self.media];
    
}
// 视频评论回复成功
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
    {
        [self.tableView reloadData];
    }

}
// 请求数据成功
- (void)_commentRequestDataSuccess:(NSNotification *)note
{
    NSArray *topicFrames = [note.userInfo objectForKey:MHCommentRequestDataSuccessKey];
    MHTopicFrame *topicFrame  = topicFrames.firstObject;
    // 这里需要判断数据 不是同一个视频  直接退出
    if (!(topicFrame.topic.mediabase_id.longLongValue == self.mediabase_id.longLongValue))
    {
        return;
    }
    
    //
    if ([self.dataSource containsObject:self.commentItem]) {
        // 包含
        // 安全处理
        // 获取索引 可能这里需要加锁  防止插入数据异常
        NSInteger index = [self.dataSource indexOfObject:self.commentItem];
        
        if (self.dataSource.count == (index+1)) {
            // 直接添加到后面
            [self.dataSource addObjectsFromArray:topicFrames];
        }else{
            // 插入数据
            NSRange range = NSMakeRange(index+1, self.dataSource.count-(1+index));
            [self.dataSource replaceObjectsInRange:range withObjectsFromArray:topicFrames];
        }
        
    }else{
        // 配置一个评论表头的假数据
        [self.dataSource addObject:self.commentItem];
        
        // 配置评论数据
        [self.dataSource addObjectsFromArray:topicFrames];
    }
    
    [self _checkTableViewFooterState:topicFrames.count>0];
    
    // 重新刷新表格
    [self.tableView reloadData];
}

// 话题点赞成功
- (void)_thumbSuccess:(NSNotificationCenter *)note
{
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - 点击事件处理
// 返回按钮点击
- (void)_backBtnDidiClicked:(MHButton *)sender
{
    // pop
    [self.navigationController popViewControllerAnimated:YES];
    // 清掉内存缓存
    [self _clearVideoTopicOrCommentCachesData];
}

// bottomToolBar的评论按钮点击
- (void)_commentVideo
{
    // 显示话题控制器
    [self _showTopicComment];
    
}

// tableView的footerBtn被点击
- (void)_commentFooterDidClicked:(UIButton *)sender
{
    // 显示topic
    [self _showTopicComment];
}


#pragma mark - 辅助方法

// 显示话题
- (void)_showTopicComment
{
    // 显示到前面来
    [self.bottomContainer bringSubviewToFront:self.topicContainer];
    //
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self _updateConstraints];
}

// 隐藏话题
- (void)_hideTopicComment
{
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(MHMainScreenHeight);
    }];
    
    [self _updateConstraints];
}

// 显示详情
- (void)_showMediaDetail
{
    [self.bottomContainer bringSubviewToFront:self.detail];
    
    [self.detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self _updateConstraints];
}
// 隐藏详情
- (void)_hideMediaDetail
{
    // 先设置约束  后添加动画
    [self.detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomContainer.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(self.bottomContainer.mas_height);
    }];
    
    [self _updateConstraints];
}

/** 更新约束 */
- (void)_updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/** topic --- topicFrame */
- (MHTopicFrame *)_topicFrameWithTopic:(MHTopic *)topic
{
    MHTopicFrame *topicFrame = [[MHTopicFrame alloc] init];
    // 传递微博模型数据，计算所有子控件的frame
    topicFrame.topic = topic;
    
    return topicFrame;
}

- (void)_refreshDataWithMedia:(MHYouKuMedia *)media
{
    // 刷新简介
    self.summary.media = media;
    
    // 刷新详情
    self.detail.media = media;
    
    // 刷新底部工具条
    self.bottomToolBar.media = media;
    
    // 添加数据
    self.commentItem.commentCount = media.commentNums;
    
    // 刷新表格
    [self.tableView reloadData];
    
    // footer设置数据
    [self.commentFooter setTitle:[NSString stringWithFormat:@"查看全部%@条回复 >" , media.commentNumsString] forState:UIControlStateNormal];
    
    // 刷新topicVC的评论的数据
    [self.topic refreshCommentsWithCommentItem:self.commentItem];
}


/** 清除掉话题评论和评论回复的内存缓存...减少内幕才能开销 */
- (void) _clearVideoTopicOrCommentCachesData
{
    [[MHTopicManager sharedManager].replyDictionary removeAllObjects];
    [[MHTopicManager sharedManager].commentDictionary removeAllObjects];
}


/** 检查状态 */
- (void)_checkTableViewFooterState:(BOOL)state
{
    if (state) {
        self.tableView.tableFooterView = self.commentFooter;
    }else{
        self.tableView.tableFooterView = nil;
    }
}
/** 刷新段  */
- (void)_reloadSelectedSectin
{
    // 获取索引
    [self.tableView beginUpdates];
    NSInteger index = [self.dataSource indexOfObject:self.selectedTopicFrame];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
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


#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.commentFrames.count;
    }
    return 0;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHCommentCell *cell = [MHCommentCell cellWithTableView:tableView];
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
        cell.commentFrame = commentFrame;
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.section];
    if ([model isKindOfClass:[MHTopicFrame class]]) {
        MHTopicFrame *videoTopicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = videoTopicFrame.commentFrames[indexPath.row];
        return commentFrame.cellHeight;
    }
    
    return .1f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.height;
    }
    
    if ([model isKindOfClass:[MHYouKuAnthologyItem class]]) {
        // 选集
        return MHRecommendAnthologyHeaderViewHeight;
    }
    
    if ([model isKindOfClass:[MHYouKuCommentItem class]]) {
        // 评论
        return MHRecommendCommentHeaderViewHeight;
    }
    
    return .1f;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // 模型
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 数据
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        return topicFrame.commentFrames.count>0? MHTopicVerticalSpace:MHGlobalBottomLineHeight;
    }
    
    // 默认高度
    return 5.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        // 话题
        MHTopicHeaderView *headerView = [MHTopicHeaderView headerViewWithTableView:tableView];
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        headerView.topicFrame = topicFrame;
        headerView.delegate = self;
        return headerView;
    }
    
    if ([model isKindOfClass:[MHYouKuAnthologyItem class]]) {
        // 选集
        MHYouKuAnthologyHeaderView *headerView = [MHYouKuAnthologyHeaderView headerViewWithTableView:tableView];
        MHYouKuAnthologyItem *anthologyItem = (MHYouKuAnthologyItem *)model;
        headerView.anthologyItem = anthologyItem;
        headerView.delegate = self;
        self.anthologyHeaderView = headerView;
        return headerView;
    }
    
    if ([model isKindOfClass:[MHYouKuCommentItem class]]) {
        // 评论
        MHYouKuCommentHeaderView *headerView = [MHYouKuCommentHeaderView headerViewWithTableView:tableView];
        MHYouKuCommentItem *commentItem = (MHYouKuCommentItem *)model;
        headerView.commentItem = commentItem;
        headerView.delegate = self;
        return headerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    id model = self.dataSource[section];
    
    // 评论
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        MHTopicFooterView *footerView = [MHTopicFooterView footerViewWithTableView:tableView];
        return footerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = self.dataSource[indexPath.section];
    
    // 评论
    if ([model isKindOfClass:[MHTopicFrame class]])
    {
        MHTopicFrame *topicFrame = (MHTopicFrame *)model;
        MHCommentFrame *commentFrame = topicFrame.commentFrames[indexPath.row];
        // 选中的栏
        self.selectedTopicFrame = topicFrame;
        
        
        // 判断
        if ([commentFrame.comment.commentId isEqualToString:MHAllCommentsId]) {
            // 跳转到更多评论
            MHYouKuTopicDetailController *topicDetail = [[MHYouKuTopicDetailController alloc] init];
            topicDetail.topicFrame = topicFrame;
            // push
            [self.navigationController pushViewController:topicDetail animated:YES];
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
}


#pragma mark - MHCommentCellDelegate
- (void)commentCell:(MHCommentCell *)commentCell didClickedUser:(MHUser *)user
{
    MHUserInfoController *userInfo = [[MHUserInfoController alloc] init];
    userInfo.user = user;
    [self.navigationController pushViewController:userInfo animated:YES];
}


#pragma mark - MHYouKuBottomToolBarDelegate
- (void) bottomToolBar:(MHYouKuBottomToolBar *)bottomToolBar didClickedButtonWithType:(MHYouKuBottomToolBarType)type
{   // bottom底部按钮被点击
    switch (type) {
        case MHYouKuBottomToolBarTypeThumb:
        {
            //
            MHLog(@"++ 点赞 ++")
            self.media.thumb = !self.media.isThumb;
            if (self.media.isThumb) {
                self.media.thumbNums+=1;
            }else{
                self.media.thumbNums-=1;
            }
            [self _refreshDataWithMedia:self.media];

        }
            break;
        case MHYouKuBottomToolBarTypeComment:
        {
            // 评论
            MHLog(@"++ 评论 ++")
            [self _commentVideo];
        }
            break;
        case MHYouKuBottomToolBarTypeCollect:
        {
            // 收藏
            MHLog(@"++ 收藏 ++")
        }
            break;
        case MHYouKuBottomToolBarTypeShare:
        {
            // 分享
            MHLog(@"++ 分享 ++")
        }
            break;
        case MHYouKuBottomToolBarTypeDownload:
        {
            // 下载
            MHLog(@"++ 下载 ++")
        }
            break;
        default:
            break;
    }
}

#pragma mark - MHYouKuTopicControllerDelegate
- (void)topicControllerForCloseAction:(MHYouKuTopicController *)topicController
{
    // 隐藏评论VC
    [self _hideTopicComment];
}

#pragma mark - MHYouKuAnthologyHeaderViewDelegate
- (void) anthologyHeaderViewForMoreButtonAction:(MHYouKuAnthologyHeaderView *)anthologyHeaderView
{
    // 更多按钮被点击
    MHLog(@"+++ 选集更多按钮点击 +++");
    
}

- (void) anthologyHeaderView:(MHYouKuAnthologyHeaderView *)anthologyHeaderView mediaBaseId:(NSString *)mediaBaseId
{
    // 选集集数按钮被点击
    MHLog(@"+++ 选集集数按钮点击 +++ %@" , mediaBaseId);
}

#pragma mark - MHYouKuCommentHeaderViewDelegate
- (void)commentHeaderViewForCommentBtnAction:(MHYouKuCommentHeaderView *)commentHeaderView
{
    // 评论按钮点击
    // 评论框按钮被点击
    MHYouKuCommentController *comment = [[MHYouKuCommentController alloc] init];
    comment.mediabase_id = self.mediabase_id;
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:comment];
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
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



#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
