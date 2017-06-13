//
//  SUTableView0Controller.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  tableView

#import "SUView0Controller.h"
#import "UIScrollView+MHRefresh.h"

@interface SUTableView0Controller : SUView0Controller<UITableViewDataSource, UITableViewDelegate>

/// 表格视图样式
@property (nonatomic, readonly , assign) UITableViewStyle style;

/// 数据源
@property (nonatomic, readonly, strong) NSMutableArray *dataSource;

/// The table view for tableView controller.
@property (nonatomic, readonly, strong) UISearchBar *searchBar;
/// tableView
@property (nonatomic, readonly, weak) UITableView *tableView;
/// 内容缩进
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/** 下来刷新 */
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/** 上拉加载 */
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;


/// 当前页
@property (nonatomic, readwrite, assign) NSUInteger currentPage;
/// 每一页的数据
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 最后一页
@property (nonatomic, readwrite, assign) NSUInteger lastPage;


/// 通过这个初始化Controller
- (instancetype)initWithStyle:(UITableViewStyle)style;

/// reload tableView data , sub class can override
- (void)reloadData;

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)tableViewDidTriggerFooterRefresh;

/**
 哪个刷新事件完成
 @param isHeader 是否是下拉刷新结束
 @param reload 是否需要刷新数据
 */
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
