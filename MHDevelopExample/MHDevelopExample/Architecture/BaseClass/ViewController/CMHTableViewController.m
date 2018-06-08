//
//  CMHTableViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHTableViewController.h"

@interface CMHTableViewController ()
/// tableView
@property (nonatomic, readwrite, weak)   UITableView *tableView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 数据源
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@end

@implementation CMHTableViewController

- (void)dealloc{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)init{
    if (self = [super init]) {
        _style = UITableViewStylePlain;
        _shouldBeginRefreshing = YES;
        _perPage = 10;
        _shouldEndRefreshingWithNoMoreData = YES;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // 设置子控件
    [self _su_setupSubViews];
}

#pragma mark - Override
- (void)configure
{
    [super configure];
    
    /// observe viewModel's dataSource
}

#pragma mark - 设置子控件
/// setup add `_su_` avoid sub class override it
- (void)_su_setupSubViews{
    // set up tableView
    /// CoderMikeHe FIXED: 纯代码布局，子类如果重新布局，建议用Masonry重新设置约束
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:self.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    /// 布局
    //    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(UIEdgeInsetsZero);
    //    }];
    
    self.tableView = tableView;
    tableView.contentInset  = self.contentInset;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /// CoderMikeHe Fixed Bug: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug 但是这样会导致 tableView 刷新一次，从而导致子类在 viewDidLoad 无法及时注册的cell，从而会有Crash的隐患
//        [self.tableView layoutIfNeeded];
//        [self.tableView setNeedsLayout];
//        [self.tableView updateConstraintsIfNeeded];
//        [self.tableView setNeedsUpdateConstraints];
//        [self.view layoutIfNeeded];
    
    /// 添加加载和刷新控件
    if (self.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView cmh_addHeaderRefresh:^(MJRefreshHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        if (self.shouldBeginRefreshing) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
    
    if (self.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView cmh_addFooterRefresh:^(MJRefreshFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
    }
    
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        /// CoderMikeHe: 适配 iPhone X + iOS 11，
        MHAdjustsScrollViewInsets_Never(tableView);
        /// iOS 11上发生tableView顶部有留白，原因是代码中只实现了heightForHeaderInSection方法，而没有实现viewForHeaderInSection方法。那样写是不规范的，只实现高度，而没有实现view，但代码这样写在iOS 11之前是没有问题的，iOS 11之后应该是由于开启了估算行高机制引起了bug。
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
#endif
    
    
}

#pragma mark - 上下拉刷新事件
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh{
    /// subclass override it
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh{
    /// subclass override it
    [self tableViewDidFinishTriggerHeader:NO reload:NO];
}

/// 结束刷新
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (reload) {
            [strongSelf.tableView reloadData];
        }
        
        if (isHeader) {
            /// 重置没有更多的状态
            if (self.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
            [strongSelf.tableView.mj_header endRefreshing];
        }
        else{
            [strongSelf.tableView.mj_footer endRefreshing];
        }
        
        /// 这里可以用来显示隐藏 mj_footer 前提你的确定好这一页的数据 perPage
        [self _requestDataCompleted];
    });
}


#pragma mark - 辅助方法
- (void)_requestDataCompleted{
    NSUInteger count = self.dataSource.count;
    /// CoderMikeHe Fixed: 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (self.shouldMultiSections) return;  // 多组的不处理
    if (self.shouldEndRefreshingWithNoMoreData && (count == 0 || count % self.perPage)) [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


#pragma mark - Override
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

/// reload tableView data
- (void)reloadData{
    [self.tableView reloadData];
}

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark - 辅助方法

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.shouldMultiSections) return self.dataSource ? self.dataSource.count : 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldMultiSections) {
        NSArray *subDataSource = self.dataSource[section];
        return subDataSource.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // fetch object
    id object = nil;
    if (self.shouldMultiSections) object = self.dataSource[indexPath.section][indexPath.row];
    if (!self.shouldMultiSections) object = self.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Setter & Getter
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource  = [[NSMutableArray alloc] init];
    }
    return _dataSource ;
}

- (void)setShouldPullDownToRefresh:(BOOL)shouldPullDownToRefresh{
    if (_shouldPullDownToRefresh != shouldPullDownToRefresh) {
        _shouldPullDownToRefresh = shouldPullDownToRefresh;
        
        if (_shouldPullDownToRefresh) {
            @weakify(self);
            [self.tableView cmh_addHeaderRefresh:^(MJRefreshHeader *header) {
                /// 加载下拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerHeaderRefresh];
            }];
        }else{
            self.tableView.mj_header = nil;
        }
    }
}

- (void)setShouldPullUpToLoadMore:(BOOL)shouldPullUpToLoadMore{
    if (_shouldPullUpToLoadMore != shouldPullUpToLoadMore) {
        _shouldPullUpToLoadMore = shouldPullUpToLoadMore;
        if (_shouldPullUpToLoadMore) {
            /// 上拉加载
            @weakify(self);
            [self.tableView cmh_addFooterRefresh:^(MJRefreshFooter *footer) {
                /// 加载上拉刷新的数据
                @strongify(self);
                [self tableViewDidTriggerFooterRefresh];
            }];
        }else{
            self.tableView.mj_footer = nil;
        }
    }
}



@end
