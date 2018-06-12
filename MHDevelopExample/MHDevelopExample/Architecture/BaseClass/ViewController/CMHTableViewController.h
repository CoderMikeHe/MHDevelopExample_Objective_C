//
//  CMHTableViewController.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  所有

#import "CMHViewController.h"

@interface CMHTableViewController : CMHViewController<UITableViewDelegate , UITableViewDataSource>

/// The table view for tableView controller. <自带全屏tableView,子类可以重新布局其frame>
/// tableView
@property (nonatomic, readonly, weak) UITableView *tableView;

/// The data source of table view <数据源懒加载>
@property (nonatomic, readonly, strong) NSMutableArray *dataSource;

/// `tableView` 的内容缩进，default is UIEdgeInsetsMake(64,0,0,0)，you can override it
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// tableView‘s style defalut is UITableViewStylePlain , 只适合 UITableView 有效
@property (nonatomic, readwrite, assign) UITableViewStyle style;

/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 是否默认开启自动刷新， YES : 系统会自动调用`tableViewDidTriggerHeaderRefresh` NO : 开发人员手动调用 `tableViewDidTriggerHeaderRefresh`
@property (nonatomic, readwrite, assign) BOOL shouldBeginRefreshing;
/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否数据是多段 (It's effect tableView's dataSource 'numberOfSectionsInTableView:') defalut is NO，但是不能跟组头组尾相关联
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;
/// 是否在上拉加载后的数据,dataSource.count < pageSize 提示没有更多的数据.default is YES 否则 隐藏mi_footer 。 前提是` shouldMultiSections = NO `才有效。
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;


/// sub class can override 且 不需要调用 [super ....]
/// reload tableView data , sub class can override
- (void)reloadData;

/// dequeueReusableCell <复用cell>
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data <为cell配置模型>
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)tableViewDidTriggerFooterRefresh;
///brief 加载结束 这个方法  子类只需要在 `tableViewDidTriggerHeaderRefresh`和`tableViewDidTriggerFooterRefresh` 结束刷新状态的时候直接调用即可，不需要重写，当然如果不喜欢内部的处理逻辑，你直接重写即可
///discussion 加载结束后，通过参数reload来判断是否需要调用tableView的reloadData，判断isHeader来停止加载
///param isHeader   是否结束下拉加载(或者上拉加载)
///param reload     是否需要重载TabeleView
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
