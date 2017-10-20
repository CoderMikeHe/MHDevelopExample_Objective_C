//
//  SUTableViewController0.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUTableViewController0.h"

@interface SUTableViewController0 ()<UIScrollViewDelegate>
/** tableView */
@property (nonatomic, readwrite, weak) UITableView *tableView;
/** contentInset defaul is (64 , 0 , 0 , 0) */
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 数据源
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@end

@implementation SUTableViewController0

- (void)dealloc
{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // config data
    _page = 1;
    _perPage = 20;
    _lastPage = 1;
    _shouldMultiSections = NO;
    _shouldPullUpToLoadMore = NO;
    _shouldPullDownToRefresh = NO;
    
    // 设置子控件
    [self _su_setupSubViews];
    
}

/// setup add `_su_` avoid sub class override it
- (void)_su_setupSubViews
{
    // set up tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:MHMainScreenBounds style:self.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset  = self.contentInset;
    self.tableView = tableView;
    [self.view addSubview:tableView];

    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /// CoderMikeHe Fixed: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug
    [self.view layoutIfNeeded];
    
    /// 添加加载和刷新控件
    if (self.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (self.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
    }
    
#ifdef __IPHONE_11_0
    MHAdjustsScrollViewInsets_Never(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
#endif
    
    
}



#pragma mark - sub class override it
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh
{
    /// 默认结束刷新
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}
/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh
{
    /// 默认结束刷新
    [self tableViewDidFinishTriggerHeader:NO reload:NO];
}

/// 刷新完成事件
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak SUTableViewController0 *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        /// 最后一页隐藏加载控件
        self.tableView.mj_footer.hidden = (self.page>=self.lastPage);
    });
}



/// sub class can override it
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(64, 0, 0, 0);
}

/// reload tableView data
- (void)reloadData
{
    [self.tableView reloadData];
}


/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}




#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.shouldMultiSections) return self.dataSource ? self.dataSource.count : 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.shouldMultiSections) return [self.dataSource[section] count];
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


#pragma mark - Getter & Setter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)setShouldPullDownToRefresh:(BOOL)shouldPullDownToRefresh
{
    if (_shouldPullDownToRefresh != shouldPullDownToRefresh) {
        _shouldPullDownToRefresh = shouldPullDownToRefresh;
        if (!_shouldPullDownToRefresh) return;
        
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
        
    }
}

- (void)setShouldPullUpToLoadMore:(BOOL)shouldPullUpToLoadMore
{
    if (_shouldPullUpToLoadMore != shouldPullUpToLoadMore) {
        _shouldPullUpToLoadMore = shouldPullUpToLoadMore;
        if (!_shouldPullUpToLoadMore) return;
        
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
    }
}
@end
