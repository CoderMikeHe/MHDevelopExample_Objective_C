//
//  SUTableViewController2.m
//  SenbaUsed
//
//  Created by senba on 2017/4/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM with RAC 开发模式的所有自定义的还有表格视图（UITableView）控制器的父类

#import "SUTableViewController2.h"



@interface SUTableViewController2 ()

/// tableView
@property (nonatomic, readwrite, weak) UITableView *tableView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 视图模型
@property (nonatomic, readonly, strong) SUTableViewModel2 *viewModel;

@end

@implementation SUTableViewController2

@dynamic viewModel;

- (void)dealloc
{
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

/// init
- (instancetype)initWithViewModel:(SUViewModel2 *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置子控件
    [self _su_setupSubViews];

}

/// override
- (void)bindViewModel
{
    [super bindViewModel];
    
    /// observe viewModel's dataSource
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSource)
       distinctUntilChanged]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         // 刷新数据
         [self reloadData];
     }];
    
    /// ...
}


/// setup add `_su_` avoid sub class override it
- (void)_su_setupSubViews
{
    // set up tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.viewModel.style];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set delegate and dataSource
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset  = self.contentInset;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    /// CoderMikeHe FIXED: 纯代码布局，子类如果重新布局，建议用Masonry重新设置约束
    tableView.frame = MHMainScreenBounds;
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    /// CoderMikeHe Fixed: 这里需要强制布局一下界面，解决由于设置了tableView的contentInset，然而contentOffset始终是（0，0）的bug
//    [self.view layoutIfNeeded];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /// 添加加载和刷新控件
    if (self.viewModel.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.tableView mh_addHeaderRefresh:^(MJRefreshNormalHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    
    if (self.viewModel.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.tableView mh_addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        
        /// 判断一下数据
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }
    
#ifdef __IPHONE_11_0
    MHAdjustsScrollViewInsets_Never(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
#endif
}

#pragma mark - sub class can override it
/// 下拉事件
- (void)tableViewDidTriggerHeaderRefresh
{
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
     	deliverOnMainThread]
    	subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.page = 1;
        } error:^(NSError *error) {
            @strongify(self)
            [self tableViewDidFinishTriggerHeader:YES reload:NO];
        } completed:^{
            @strongify(self)
            /// 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据
            [self tableViewDidFinishTriggerHeader:YES reload:NO];
        }];
}

/// 上拉事件
- (void)tableViewDidTriggerFooterRefresh
{
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand
       execute:@(self.viewModel.page + 1)]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         self.viewModel.page += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self tableViewDidFinishTriggerHeader:NO reload:NO];
     } completed:^{
         @strongify(self)
         [self tableViewDidFinishTriggerHeader:NO reload:NO];
     }];
}

/// 刷新完成事件
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak SUTableViewController2 *weakSelf = self;
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
        self.tableView.mj_footer.hidden = (self.viewModel.page>=self.viewModel.lastPage);
    });

}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(64, 0, 0, 0);
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


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.shouldMultiSections) return [self.viewModel.dataSource[section] count];
    
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    id object = nil;
    if (self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (!self.viewModel.shouldMultiSections) object = self.viewModel.dataSource[indexPath.row];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // execute commond
    [self.viewModel.didSelectCommand execute:indexPath];
}

@end
