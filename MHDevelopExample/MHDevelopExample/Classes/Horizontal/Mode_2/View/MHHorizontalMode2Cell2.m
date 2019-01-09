//
//  MHHorizontalMode2Cell2.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/25.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalMode2Cell2.h"
#import "MHHorizontalMode1Cell.h"
#import "MHHorizontalConstant.h"
#import "MHHorizontalGroup.h"
#import "MHCollectionViewHorizontalFlowLayout.h"
@interface MHHorizontalMode2Cell2 ()<UICollectionViewDelegate,UICollectionViewDataSource,MHHorizontalCellDelegate>

/// UICollectionView
@property (nonatomic, readwrite, weak) UICollectionView *collectionView;
/// pageCount
@property (nonatomic, readwrite, assign) NSUInteger pageCount;
/// dataSource
@property (nonatomic, readwrite, copy) NSArray *dataSource;
/// 记录刚开始时的偏移量
@property (nonatomic, readwrite, assign) NSInteger startOffsetX;
/// 标记内容滚动
@property (nonatomic, readwrite, assign) BOOL isScroll;
@end

@implementation MHHorizontalMode2Cell2

#pragma mark - Setter
- (void)setGroup:(MHHorizontalGroup *)group{
    _group = group;
    self.dataSource = group.horizontals;
    [self.collectionView reloadData];
    
#warning CMH : ⚠️  这里必须将collectionView滚到currentPage
    CGFloat offsetX = group.currentPage * self.mh_width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
#warning CMH : ⚠️  这里需要强行将自己刷新一波布局
        /// 强行然自己刷新一波
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
    _isScroll = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isScroll == NO) { return; }
    
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > _startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.dataSource.count) {
            progress = 1;
            targetIndex = self.dataSource.count - 1;
        }
        // 4、如果完全划过去
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    } else { // 右滑
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.dataSource.count) {
            originalIndex = self.dataSource.count - 1;
        }
    }
    // 3、collectionViewCellDelegate; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCell:progress:originalIndex:targetIndex:)]) {
        [self.delegate collectionViewCell:self progress:progress originalIndex:originalIndex targetIndex:targetIndex];
    }
}


#pragma mark - - - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHHorizontalMode1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHHorizontalMode1Cell" forIndexPath:indexPath];
    cell.horizontal = self.dataSource[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - MHHorizontalCellDelegate
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    MHHorizontal *hz = self.dataSource[indexPath.item];
    /// 回调数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCellTapAction:sourceData:)]) {
        [self.delegate collectionViewCellTapAction:self sourceData:hz];
    }
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
}

/// 创建子控件
- (void)_setupSubviews{
    /// 设置布局
    MHCollectionViewHorizontalFlowLayout *flowLayout = [[MHCollectionViewHorizontalFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = MHHorizontalMinimumLineSpacing ;
    flowLayout.minimumInteritemSpacing = MHHorizontalMinimumInteritemSpacing;
    flowLayout.sectionInset = MHHorizontalSectionInset();
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    /// 设置 row & column
    flowLayout.columnCount = MHHorizontalMaxColumn;
    flowLayout.rowCount = MHHorizontalMaxRow;
    
    /// 计算item 宽高
    CGFloat W = CGFloatPixelFloor((MH_SCREEN_WIDTH - flowLayout.sectionInset.left - flowLayout.sectionInset.right - (flowLayout.columnCount - 1) * flowLayout.minimumInteritemSpacing)/flowLayout.columnCount);
    CGFloat H = CGFloatPixelFloor((MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT - CMHBottomMargin(49) - flowLayout.sectionInset.bottom - flowLayout.sectionInset.top - (flowLayout.rowCount - 1) * flowLayout.minimumLineSpacing)/flowLayout.rowCount);
    
    flowLayout.itemSize = CGSizeMake(W, H);
    
    /// 设置collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
    collectionView.bounces = NO;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self.contentView addSubview:collectionView];
    /// 注册CellID
    [collectionView registerClass:[MHHorizontalMode1Cell class] forCellWithReuseIdentifier:NSStringFromClass(MHHorizontalMode1Cell.class)];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

@end


