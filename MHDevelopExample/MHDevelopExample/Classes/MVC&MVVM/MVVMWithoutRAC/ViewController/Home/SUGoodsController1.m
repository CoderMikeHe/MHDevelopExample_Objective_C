//
//  SUGoodsController1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的商品首页控制器 -- C

#import "SUGoodsController1.h"
#import "SUSearchBarView.h"
#import "SDCycleScrollView.h"
#import "SUGoodsCell.h"
#import "SUGoodsHeaderView.h"
#import "SUPublicController1.h"
#import "SUPublicWebController1.h"
//// 全局变量
static UIStatusBarStyle style_ = UIStatusBarStyleDefault;
static BOOL statusBarHidden_ = NO;

@interface SUGoodsController1 ()
/// 模型视图
@property (nonatomic, readonly, strong) SUGoodsViewModel1 *viewModel;
/// 滚动到顶部的按钮
@property (nonatomic, readwrite, weak) UIButton *scrollToTopButton;
/// 自定义的导航条
@property (nonatomic, readwrite, weak) UIView *navBar;
/// searchBar
@property (nonatomic, readwrite, weak) SUSearchBarView *titleView;
/// headerView
@property (nonatomic, readwrite, weak) SDCycleScrollView *headerView;
@end

@implementation SUGoodsController1
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}
@dynamic viewModel;

- (void)dealloc
{
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
    self.tableView.estimatedRowHeight = 280.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    /// bind viewModel
    [self _bindViewModel];
}

#pragma mark - BindModel
- (void)_bindViewModel{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
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
        SUPublicWebViewModel1 *viewModel = [[SUPublicWebViewModel1 alloc] initWithParams:@{SUViewModelRequestKey:[self.viewModel banerUrlWithIndex:currentIndex]}];
        SUPublicWebController1 *webViewVc = [[SUPublicWebController1 alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:webViewVc animated:YES];
    };
}
/// 滚动到顶部
- (void)_scrollToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark - Override
//// 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh{
    /// 先调用父类的加载数据
    [super tableViewDidTriggerHeaderRefresh];
    /// 加载banners data
    [self.viewModel loadBannerData:^(id responseObject) {
        /// 配置数据
        self.headerView.imageURLStringsGroup = self.viewModel.banners;
        self.headerView.hidden = !(self.viewModel.banners.count>0);
    } failure:nil];
}
/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    SUGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SUGoodsCell class])];
    /// 处理事件
    @weakify(self);
    /// 头像
    cell.avatarClickedHandler = ^(SUGoodsCell *goodsCell) {
        @strongify(self);
        SUGoodsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
        [self _pushToPublicViewControllerWithTitle:viewModel.goods.nickName];
    };
    /// 位置
    cell.locationClickedHandler = ^(SUGoodsCell *goodsCell) {
        @strongify(self);
        SUGoodsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
        [self _pushToPublicViewControllerWithTitle:viewModel.goods.locationAreaName];
    };
    
    /// 回复
    cell.replyClickedHandler = ^(SUGoodsCell *goodsCell) {
        @strongify(self);
        SUGoodsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
        [self _pushToPublicViewControllerWithTitle:[NSString stringWithFormat:@"商品%@的评论列表",viewModel.goods.goodsId]];
    };
    
    /// 点赞
    cell.thumbClickedHandler = ^(SUGoodsCell *goodsCell) {
        @strongify(self);
        /// show loading
        [MBProgressHUD mh_showProgressHUD:@"Loading..." addedToView:self.view];
        SUGoodsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.row];
        /// 点赞
        [self.viewModel thumbGoodsWithGoodsItemViewModel:viewModel success:^(NSNumber * responseObject) {
            [MBProgressHUD mh_hideHUDForView:self.view];
            NSString *tips = (responseObject.boolValue)?@"收藏商品成功":@"取消收藏商品";
            [MBProgressHUD mh_showTips:tips];
            /// reload data
            [self.tableView reloadData];
        } failure:nil];
    };
    return cell;
}

/// config  data
- (void)configureCell:(SUGoodsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(SUGoodsItemViewModel *)object
{
    /// config data (PS：由于MVVM主要是View与数据之间的绑定，但是跟 setViewModel: 差不多啦)
    [cell bindViewModel:object];
}

/// 文本内容区域
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsZero;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转到商品详请
    [self _pushToPublicViewControllerWithTitle:@"商品详情"];
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
- (void)_pushToPublicViewControllerWithTitle:(NSString *)title
{
    SUPublicViewModel1 *viewModel = [[SUPublicViewModel1 alloc] initWithParams:@{SUViewModelTitleKey:title}];
    SUPublicController1 *publicVC = [[SUPublicController1 alloc] initWithViewModel:viewModel];
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
    //// 添加事件处理
    [scrollToTopButton addTarget:self action:@selector(_scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    
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
