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


@interface MHYouKuController ()<UITableViewDelegate,UITableViewDataSource , MHCommentCellDelegate ,MHTopicHeaderViewDelegate,MHYouKuBottomToolBarDelegate,MHYouKuTopicControllerDelegate>

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






/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;

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
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter

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

#pragma mark -  初始化数据，假数据





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
    
    // 容器
    [self _setupTopicContainer];
    
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
    
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    //
}

#pragma mark - 通知事件处理


#pragma mark - 点击事件处理
// 返回按钮点击
- (void)_backBtnDidiClicked:(MHButton *)sender
{
    // 
    [self.navigationController popViewControllerAnimated:YES];
}

// bottomToolBar的评论按钮点击
- (void)_commentVideo
{
    // 显示话题控制器
    [self _showTopicComment];
    
}



#pragma mark - 辅助方法

- (void)_showTopicComment
{
    [self.bottomContainer bringSubviewToFront:self.topContainer];
    //
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)_hideTopicComment
{
    [self.topicContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(MHMainScreenHeight);
    }];
    
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


#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - MHYouKuBottomToolBarDelegate
- (void) bottomToolBar:(MHYouKuBottomToolBar *)bottomToolBar didClickedButtonWithType:(MHYouKuBottomToolBarType)type
{
    switch (type) {
        case MHYouKuBottomToolBarTypeThumb:
        {
            //
            MHLog(@"++ 点赞 ++")
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
    // 隐藏
    [self _hideTopicComment];
}



#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
