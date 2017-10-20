//
//  SUGoodsController2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoodsController2.h"
#import "SUSearchBarView.h"
#import "SDCycleScrollView.h"
#import "SUGoodsCell.h"
#import "SUGoodsHeaderView.h"
#import "SUPublicController2.h"
#import "SUPublicWebController2.h"

//// 全局变量
static UIStatusBarStyle style_ = UIStatusBarStyleDefault;
static BOOL statusBarHidden_ = NO;
@interface SUGoodsController2 ()

/// 模型视图
@property (nonatomic, readonly, strong) SUGoodsViewModel2 *viewModel;
/// 滚动到顶部的按钮
@property (nonatomic, readwrite, weak) UIButton *scrollToTopButton;
/// 自定义的导航条
@property (nonatomic, readwrite, weak) UIView *navBar;
/// searchBar
@property (nonatomic, readwrite, weak) SUSearchBarView *titleView;
/// headerView
@property (nonatomic, readwrite, weak) SDCycleScrollView *headerView;
@end

@implementation SUGoodsController2
@dynamic viewModel;

- (void)dealloc{
    MHDealloc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    [self.headerView adjustWhenControllerViewWillAppera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide sys navBar
    self.fd_prefersNavigationBarHidden = YES;
    // 去掉侧滑pop手势
    self.fd_interactivePopDisabled = YES;
    // create subViews
    [self _setupSubViews];
    // deal action
    [self _dealAction];
    /// tableView rigister  cell
    [self.tableView mh_registerNibCell:[SUGoodsCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SUGoodsHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SUGoodsHeaderView class])];
    
    /// estimatedRowHeight
    /// Fixed：如果添加下面👇代码 会导致当表格滚动到大于一页的时候 ，点击右下角的返回到顶部的按钮 无法滚动到顶部的bug。原因还在排查中...
    //    self.tableView.estimatedRowHeight = 280.0f;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - 事件处理
/// 事件处理
- (void)_dealAction
{
    /// 点击搜索框的事件：这里我就不跳转到搜索界面了  直接退出该界面
    @weakify(self);
    self.titleView.searchBarViewClicked = ^ {
        @strongify(self);
        @weakify(self);
        UIAlertAction *confirmlAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定要注销当前用户吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:confirmlAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    /// banner 视图被点击
    self.headerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        SUPublicWebViewModel2 *viewModel = [[SUPublicWebViewModel2 alloc] initWithParams:@{SUViewModelRequestKey:[self.viewModel bannerUrlWithIndex:currentIndex]}];
        SUPublicWebController2 *webViewVc = [[SUPublicWebController2 alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:webViewVc animated:YES];
    };
    
    /// 滚动到顶部的按钮事件
    [[self.scrollToTopButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
     }];
}


#pragma mark - Override
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    /// 1. 监听banners的数据变化
    [RACObserve(self.viewModel, banners) subscribeNext:^(id x) {
        /// 配置数据
        @strongify(self);
        self.headerView.imageURLStringsGroup = self.viewModel.banners;
        self.headerView.hidden = !(self.viewModel.banners.count>0);
    }];
    
    /// 2. 处理cell上的点击事件（PS：如果cell的数据不是异步请求的数据，那么就用 RACSubject 代替代理（block） ，否则也可以用 RACCommand代替代理（block），但是建议用 RACSubject，但是RACSubject过于灵活）
    /// cell被点击
    self.viewModel.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self);
        // 跳转到商品详请
        [self _pushToPublicViewControllerWithTitle:@"商品详情"];
        return [RACSignal empty];
    }];
    
    /// cell 头像被点击
    [self.viewModel.didClickedAvatarSubject subscribeNext:^(SUGoodsItemViewModel * viewModel) {
        @strongify(self);
        [self _pushToPublicViewControllerWithTitle:viewModel.goods.nickName];
    }];
    
    /// cell 地址被点击
    [self.viewModel.didClickedLocationSubject subscribeNext:^(SUGoodsItemViewModel * viewModel) {
        @strongify(self);
        [self _pushToPublicViewControllerWithTitle:viewModel.goods.locationAreaName];
    }];
    
    /// cell 回复被点击
    [self.viewModel.didClickedReplySubject subscribeNext:^(SUGoodsItemViewModel * viewModel) {
        @strongify(self);
        [self _pushToPublicViewControllerWithTitle:[NSString stringWithFormat:@"商品%@的评论列表",viewModel.goods.goodsId]];
    }];
    
    /// 
}

//// 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh{
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    
    /// 加载banners data
    [self.viewModel.requestBannerDataCommand execute:nil];
}
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SUGoodsCell class])];
}

/// config  data
- (void)configureCell:(SUGoodsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(SUGoodsItemViewModel *)object{
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

/// 文本内容区域
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 由于使用系统的autoLayout来计算cell的高度，每次滚动时都要重新计算cell的布局以此来获得cell的高度 这样一来性能不好
    /// 所以笔者采用实现计算好的cell的高度
    return [self.viewModel.dataSource[indexPath.row] cellHeight];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    self.scrollToTopButton.hidden = (offsetY < scrollView.mh_height);
    
    CGFloat duration = 0.65;
    CGFloat titleViewAlpha = (offsetY >= 0)?1.0:0.;
    CGFloat navBarAlhpa = (offsetY >= self.headerView.mh_height)?1.0:0.0;
    
    navBarAlhpa = (offsetY - self.headerView.mh_height) / self.headerView.mh_height + 1;
    
    [UIView animateWithDuration:duration animations:^{
        self.navBar.backgroundColor = MHAlphaColor(254.0f, 132.0f, 154.0f, navBarAlhpa);
        self.titleView.alpha = titleViewAlpha;
    }];
    
    UIStatusBarStyle tempStyle = (offsetY >= self.headerView.mh_height)?UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
    BOOL tempStatusBarHidden = (offsetY >= 0)?NO:YES;
    
    if ((tempStyle == style_) && (tempStatusBarHidden == statusBarHidden_)) {
    } else {
        style_ = tempStyle;
        statusBarHidden_ = tempStatusBarHidden;
        /// 更新状态栏
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - 辅助方法
/// 跳转界面 这里只是一个跳转，实际情况，自行定夺
- (void)_pushToPublicViewControllerWithTitle:(NSString *)title{
    SUPublicViewModel2 *viewModel = [[SUPublicViewModel2 alloc] initWithParams:@{SUViewModelTitleKey:title}];
    SUPublicController2 *publicVC = [[SUPublicController2 alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:publicVC animated:YES];
}





////////////////// 以下为UI代码，不必过多关注 ///////////////////
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /// FIXED : when data is empty ，the backgroundColor is exist
    return (self.viewModel.dataSource.count==0)?.0001f:53;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /// FIXED : when data is empty ，show nothing
    if (self.viewModel.dataSource.count==0) return nil;
    
    SUGoodsHeaderView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SUGoodsHeaderView class])];
    sectionHeader.backgroundColor = self.view.backgroundColor;
    return sectionHeader;
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return style_;
}
- (BOOL)prefersStatusBarHidden {
    return statusBarHidden_;
}

#pragma mark - 初始化子控件
- (void)_setupSubViews
{
    /// Create NavBar;
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MHMainScreenWidth, self.navigationController.navigationBar.mh_height+20)];
    navBar.backgroundColor = MHAlphaColor(254.0f, 88.0f, 62.0f, .0f) ;
    self.navBar = navBar;
    [self.view addSubview:navBar];
    
    /// 搜索框View
    CGFloat titleViewX = 26;
    CGFloat titleViewH = 28;
    CGFloat titleViewY = 20 + floor((navBar.mh_height - 20 - titleViewH)/2);
    CGFloat titleViewW = MHMainScreenWidth - 2 * titleViewX;
    SUSearchBarView *titleView = [[SUSearchBarView alloc] initWithFrame:CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH)];
    titleView.backgroundColor = [UIColor whiteColor];
    self.titleView = titleView;
    [navBar addSubview:titleView];
    
    /// 滚动到顶部的按钮
    CGFloat scrollToTopButtonW = 52;
    CGFloat scrollToTopButtonH = 90;
    CGFloat scrollToTopButtonX = (MHMainScreenWidth - scrollToTopButtonW) - 12;
    CGFloat scrollToTopButtonY = (MHMainScreenHeight - scrollToTopButtonH) - 60;
    UIButton *scrollToTopButton = [[UIButton alloc] initWithFrame:CGRectMake(scrollToTopButtonX, scrollToTopButtonY, scrollToTopButtonW, scrollToTopButtonH)];
    [scrollToTopButton setImage:[UIImage imageNamed:@"home_page_scroll_to_top"] forState:UIControlStateNormal];
    scrollToTopButton.hidden = YES;
    self.scrollToTopButton = scrollToTopButton;
    [self.view addSubview:scrollToTopButton];

    /// 头视图 banner
    SDCycleScrollView *headerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.mh_width, SUGoodsBannerViewHeight)];
    headerView.autoScrollTimeInterval = 5.0f;
    headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    headerView.placeholderImage = placeholderImage();
    self.headerView = headerView;
    /// default is Hidden until have data to show
    headerView.hidden = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
}
@end
