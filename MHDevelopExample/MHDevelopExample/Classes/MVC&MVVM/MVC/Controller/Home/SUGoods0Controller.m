//
//  SUGoods0Controller.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoods0Controller.h"
#import "SUSearchBarView.h"
#import "SDCycleScrollView.h"
#import "SUGoodsData.h"
#import "SUGoodsFrame.h"
#import "SUBanner.h"
#import "SUGoodsCell.h"
#import "SUGoodsHeaderView.h"
#import "SUPublic0ViewController.h"

//// 全局变量
static UIStatusBarStyle style_ = UIStatusBarStyleDefault;
static BOOL statusBarHidden_ = NO;

@interface SUGoods0Controller ()
/// 滚动到顶部的按钮
@property (nonatomic, readwrite, weak) UIButton *scrollToTopButton;
/// 自定义的导航条
@property (nonatomic, readwrite, weak) UIView *navBar;
/// searchBar
@property (nonatomic, readwrite, weak) SUSearchBarView *titleView;
/// headerView
@property (nonatomic, readwrite, weak) SDCycleScrollView *headerView;
/// banners
@property (nonatomic, readwrite, copy) NSArray *banners;
@end

@implementation SUGoods0Controller
- (void)dealloc
{
    MHDealloc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
    [self.headerView adjustWhenControllerViewWillAppera];
    
    
    NSLog(@"mmmm----before %@ ---" , NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"mmmm----after %@ ---" , NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide sys navBar
    self.fd_prefersNavigationBarHidden = YES;
    
    // create subViews
    [self _setupSubViews];

    // deal action
    [self _dealAction];
    
    // config tableView
    self.shouldPullDownToRefresh = YES;
    self.shouldPullUpToLoadMore = YES;
    self.tableView.mj_footer.hidden = YES;
    
    /// tableView rigister  cell
    [self.tableView mh_registerNibCell:[SUGoodsCell class]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SUGoodsHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SUGoodsHeaderView class])];
    
    /// estimatedRowHeight
    self.tableView.estimatedRowHeight = 280.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark - 事件处理
/// 事件处理
- (void)_dealAction
{
    /// 点击搜索框的事件：这里我就不跳转到搜索界面了  直接退出该界面
    @weakify(self);
    self.titleView.searchBarViewClicked = ^ {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    /// banner 视图被点击
    self.headerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//        @strongify(self);
        
    
    };
}
/// 滚动到顶部
- (void)_scrollToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Override
/// 下拉刷新
- (void)tableViewDidTriggerHeaderRefresh
{
    /// page reset to 0
    self.page = 0;
    
    /// config param
    NSInteger page = self.page+1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(page) forKey:@"page"];
    
    /// 请求商品数据
    /// 请求商品数据 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 移除掉数据
        [self.dataSource removeAllObjects];
        /// 获取数据
        NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"SUGoodsData_%zd.data",(page)]];
        SUGoodsData *goodsData = [SUGoodsData modelWithJSON:data];
        /// 转化数据
        NSArray *dataSource = [self _dataSourceWithGoodsData:goodsData];
        /// 添加数据
        [self.dataSource addObjectsFromArray:dataSource];
        /// 结束头部控件的刷新并刷新数据
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
    });
    
    /// 请求banner数据 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 获取数据
        NSData *data = [NSData dataNamed:@"SUBannerData.data"];
        /// convert to model array
        self.banners = [SUBanner modelArrayWithJSON:data];
        
        /// 配置数据
        self.headerView.imageURLStringsGroup = [self _bannerImageUrlStringsWithBanners:self.banners];
        self.headerView.hidden = !(self.banners.count>0);
    });
    
    
}
/// 上拉加载
- (void)tableViewDidTriggerFooterRefresh
{
    /// config param
    NSInteger page = self.page+1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(page) forKey:@"page"];
    
    /// 请求商品数据
    /// 请求商品数据 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 获取数据
        NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"SUGoodsData_%zd.data",(page)]];
        SUGoodsData *goodsData = [SUGoodsData modelWithJSON:data];
        /// 转化数据
        NSArray *dataSource = [self _dataSourceWithGoodsData:goodsData];
        /// 添加数据
        [self.dataSource addObjectsFromArray:dataSource];
        /// 结束尾部控件的刷新并刷新数据
        [self tableViewDidFinishTriggerHeader:NO reload:YES];
    });
}

/// config  cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    SUGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SUGoodsCell class])];
    return cell;
}

/// config  data
- (void)configureCell:(SUGoodsCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(SUGoodsFrame *)object
{
    /// config data
    cell.goodsFrame = object;
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
//// banner data
- (NSArray *)_bannerImageUrlStringsWithBanners:(NSArray *)banners
{
    NSMutableArray *bannerImageUrlString = [NSMutableArray arrayWithCapacity:banners.count];
    
    [banners enumerateObjectsUsingBlock:^(SUBanner * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (MHStringIsNotEmpty(obj.image.url)) {
            [bannerImageUrlString addObject:obj.image.url];
        } else {
            [bannerImageUrlString addObject:@""];
        }
    }];
    return bannerImageUrlString.copy;
}

/// 处理goodsData
- (NSArray *)_dataSourceWithGoodsData:(SUGoodsData *)goodsData
{
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:goodsData.data.count];
    
    for (SUGoods *goods in goodsData.data) {
        SUGoodsFrame *goodsFrame = [[SUGoodsFrame alloc] initWithGoods:goods];
        [dataSource addObject:goodsFrame];
    }
    /// config data
    self.page = goodsData.currentPage;
    self.lastPage = goodsData.lastPage;
    self.perPage = goodsData.perPage;
    return dataSource.copy;
}

/// 跳转界面 这里只是一个跳转，实际情况，自行定夺
- (void)_pushToPublicViewControllerWithTitle:(NSString *)title
{
    SUPublic0ViewController *publicVC = [[SUPublic0ViewController alloc] init];
    publicVC.title = title;
    [self.navigationController pushViewController:publicVC animated:YES];
}




////////////////// 以下为UI代码，不必过多关注 ///////////////////
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 53;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /// FIXED : when data is empty ，show nothing
    if (self.dataSource.count==0) return nil;
    SUGoodsHeaderView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SUGoodsHeaderView class])];
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
    CGFloat scrollToTopButtonX = (self.tableView.mh_width - scrollToTopButtonW) - 12;
    CGFloat scrollToTopButtonY = (self.tableView.mh_height - scrollToTopButtonH) - 15;
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
    
    self.tableView.contentInset = self.contentInset;
}
@end
