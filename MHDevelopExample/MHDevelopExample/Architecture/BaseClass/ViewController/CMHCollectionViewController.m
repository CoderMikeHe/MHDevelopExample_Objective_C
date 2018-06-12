//
//  CMHCollectionViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHCollectionViewController.h"

@interface CMHCollectionViewController ()
/// collectionView
@property (nonatomic , readwrite , weak) UICollectionView *collectionView;
/// contentInset defaul is (64 , 0 , 0 , 0)
@property (nonatomic, readwrite, assign) UIEdgeInsets contentInset;
/// 数据源
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@end

@implementation CMHCollectionViewController

- (void)dealloc{
    // set nil
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}


- (instancetype)init{
    if (self = [super init]) {
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _shouldBeginRefreshing = YES;
        _page = 1;
        _perPage = 20;
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
    
    /// UICollectionViewFlowLayout + UICollectionView
    if (self.collectionViewLayout == nil) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = self.scrollDirection;
        self.collectionViewLayout = flowLayout;
    }
    
    /// CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.collectionViewLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    /// 设置显示区域
    collectionView.contentInset  = self.contentInset;
    
    /// 注册cell
    [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    /// 添加加载和刷新控件
    if (self.shouldPullDownToRefresh) {
        /// 下拉刷新
        @weakify(self);
        [self.collectionView mh_addHeaderRefresh:^(MJRefreshHeader *header) {
            /// 加载下拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerHeaderRefresh];
        }];
        if (self.shouldBeginRefreshing) {
            [self.collectionView.mj_header beginRefreshing];
        }
    }
    
    if (self.shouldPullUpToLoadMore) {
        /// 上拉加载
        @weakify(self);
        [self.collectionView mh_addFooterRefresh:^(MJRefreshFooter *footer) {
            /// 加载上拉刷新的数据
            @strongify(self);
            [self collectionViewDidTriggerFooterRefresh];
        }];
        
        /// CoderMikeHe Fixed Bug : 这里先隐藏，防止一进来用户看到上拉加载控件，影响美观
        self.collectionView.mj_footer.hidden = YES;
    }
    
#ifdef __IPHONE_11_0
    /// CoderMikeHe: 适配 iPhone X + iOS 11，
    MHAdjustsScrollViewInsets_Never(collectionView);
#endif
    
}

#pragma mark - 上下拉刷新事件
/// 下拉事件
- (void)collectionViewDidTriggerHeaderRefresh{
    /// subclass override it
    [self collectionViewDidFinishTriggerHeader:YES reload:NO];
}

/// 上拉事件
- (void)collectionViewDidTriggerFooterRefresh{
    /// subclass override it
    [self collectionViewDidFinishTriggerHeader:NO reload:NO];
}

/// 结束刷新
- (void)collectionViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (reload) {
            [strongSelf.collectionView reloadData];
        }
        if (isHeader) {
            /// 重置没有更多的状态
            if (self.shouldEndRefreshingWithNoMoreData){
                [self.collectionView.mj_footer setHidden:NO];
                [self.collectionView.mj_footer resetNoMoreData];
            }else{
                [self.collectionView.mj_footer setHidden:NO];
            }
            [strongSelf.collectionView.mj_header endRefreshing];
        }
        else{
            [strongSelf.collectionView.mj_footer endRefreshing];
        }
        
        /// 这里可以用来显示隐藏 mj_footer
        [self _requestDataCompleted];
        
    });
}

- (void)_requestDataCompleted{
    
    NSUInteger count = self.dataSource.count;
    /// CoderMikeHe Fixed: 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (self.shouldMultiSections) return;  // 多组的不处理
    
    if (count == 0 || count % self.perPage) {
        
        if (self.shouldEndRefreshingWithNoMoreData) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            self.collectionView.mj_footer.hidden = YES;
        }
    }
}



#pragma mark - sub class can override it
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

/// reload tableView data
- (void)reloadData{
    [self.collectionView reloadData];
}

/// dequeueReusable Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark - UICollectionViewDataSource&UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.shouldMultiSections) return self.dataSource ? self.dataSource.count : 0;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.shouldMultiSections) {
        NSArray *subDataSource = self.dataSource[section];
        return subDataSource.count;
    }
    return self.dataSource.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self collectionView:collectionView dequeueReusableCellWithIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    // fetch object
    id object = nil;
    if (self.shouldMultiSections) object = self.dataSource[indexPath.section][indexPath.item];
    if (!self.shouldMultiSections) object = self.dataSource[indexPath.item];
    
    /// bind model
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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
            [self.collectionView cmh_addHeaderRefresh:^(MJRefreshHeader *header) {
                /// 加载下拉刷新的数据
                @strongify(self);
                [self collectionViewDidTriggerHeaderRefresh];
            }];
        }else{
            self.collectionView.mj_header = nil;
        }
    }
}

- (void)setShouldPullUpToLoadMore:(BOOL)shouldPullUpToLoadMore{
    if (_shouldPullUpToLoadMore != shouldPullUpToLoadMore) {
        _shouldPullUpToLoadMore = shouldPullUpToLoadMore;
        if (_shouldPullUpToLoadMore) {
            /// 上拉加载
            @weakify(self);
            [self.collectionView cmh_addFooterRefresh:^(MJRefreshFooter *footer) {
                /// 加载上拉刷新的数据
                @strongify(self);
                [self collectionViewDidTriggerFooterRefresh];
            }];
        }else{
            self.collectionView.mj_footer = nil;
        }
    }
}

@end
