//
//  CMHCollectionViewController.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
// CMHCollectionViewController 跟 CMHTableViewViewController 使用类似

#import "CMHViewController.h"

@interface CMHCollectionViewController : CMHViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/// The table view for collectionView controller.
/// tableView
@property (nonatomic, readonly, weak) UICollectionView *collectionView;
/// collectionView 的布局，默认是 `UICollectionViewFlowLayout`
@property (nonatomic, readwrite, strong) UICollectionViewLayout *collectionViewLayout;
/// The data source of table view
@property (nonatomic, readonly, strong) NSMutableArray *dataSource;

/// `collectionView` 的内容缩进，default is UIEdgeInsetsMake(64,0,0,0)，you can override it
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

// 滚动方向 default is UICollectionViewScrollDirectionVertical
@property (nonatomic, readwrite, assign) UICollectionViewScrollDirection scrollDirection;

/// 需要支持下来刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 是否默认开启自动刷新， YES : 系统会自动调用`collectionViewDidTriggerHeaderRefresh` NO : 开发人员手动调用 `collectionViewDidTriggerHeaderRefresh`
@property (nonatomic, readwrite, assign) BOOL shouldBeginRefreshing;
/// 需要支持上拉加载 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否数据是多段 (It's effect collectionView's dataSource 'numberOfSectionsInTableView:') defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;
/// 是否在上拉加载后的数据,dataSource.count < pageSize 提示没有更多的数据.default is YES 默认做法是数据不够时，隐藏mj_footer
@property (nonatomic, readwrite, assign) BOOL shouldEndRefreshingWithNoMoreData;

/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;


/// sub class can override 且 不需要调用 [super ....]
/// reload tableView data , sub class can override
- (void)reloadData;

/// equeueReusableCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)collectionViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)collectionViewDidTriggerFooterRefresh;
///brief 加载结束 这个方法  子类只需要在 `collectionViewDidTriggerHeaderRefresh`和`collectionViewDidTriggerFooterRefresh` 结束刷新状态的时候直接调用即可，不需要重写，当然如果不喜欢内部的处理逻辑，你直接重写即可
///discussion 加载结束后，通过参数reload来判断是否需要调用collectionView的reloadData，判断isHeader来停止加载
///param isHeader   是否结束下拉加载(或者上拉加载)
///param reload     是否需要重载TabeleView
///
- (void)collectionViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
