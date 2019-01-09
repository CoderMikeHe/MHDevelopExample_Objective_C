//
//  MHHorizontalMode2Cell1.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/25.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalMode2Cell1.h"
#import "MHHorizontalMode1Cell.h"
#import "MHHorizontalEmptyCell.h"
#import "MHHorizontalConstant.h"
#import "MHHorizontalGroup.h"
@interface MHHorizontalMode2Cell1 ()<UICollectionViewDelegate,UICollectionViewDataSource,MHHorizontalCellDelegate>

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

@implementation MHHorizontalMode2Cell1

#pragma mark - Setter
- (void)setGroup:(MHHorizontalGroup *)group{
    _group = group;
    
    NSInteger count = group.horizontals.count;
    NSMutableArray *temps = [NSMutableArray array];
    
    /// 计算分页总数公式： pageCount = (totalrecords + pageSize - 1) / pageSize  //取得所有页数
    NSInteger pageCount = (count + MHHorizontalPageSize - 1)/MHHorizontalPageSize;
    
    /// 计算数据
    for (NSInteger page = 0; page < pageCount; page++) {
        /// 计算range
        NSInteger loc = page * MHHorizontalPageSize;
        NSInteger len = (page < (pageCount-1))?MHHorizontalPageSize:(count%MHHorizontalPageSize);
        /// 取出数据
        NSArray *arr = [group.horizontals subarrayWithRange:NSMakeRange(loc, len)];
        /// 添加数组
        [temps addObject:arr];
    }
    
    self.dataSource = temps.copy;
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
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MHHorizontalPageSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tempArray = self.dataSource[indexPath.section];
    NSInteger count = tempArray.count;
    /// 需要颠倒 transpose row/col
    NSInteger dataIndex = [self _transposeToDataIndexFromUIIndex:indexPath.item];
#warning CMH : ⚠️ 当前段不满 pageSize 的用 emptyCell
    if (dataIndex < count) {
        MHHorizontalMode1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHHorizontalMode1Cell" forIndexPath:indexPath];
        cell.horizontal = tempArray[dataIndex];
        cell.delegate = self;
        return cell;
    }else{
        MHHorizontalEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHHorizontalEmptyCell" forIndexPath:indexPath];
        return cell;
    }
}


/// 颠倒row/col
/* 水平布局的collectionView显示cell的顺序是:
 * (3x3) 0, 3, 6
 *       1, 4, 7
 *       2, 5, 8
 *
 * 实际一页需要显示的顺序是:
 * (3x3) 0, 1, 2
 *       3, 4, 5
 *       6, 7, 8
 */
- (NSInteger)_transposeToDataIndexFromUIIndex:(NSInteger)uiIndex{
    //    return [self _way0_dataIndexFromUIIndex:uiIndex];
    return [self _way1_dataIndexFromUIIndex:uiIndex];
}
/// 方式一
/// 根据UI索引返回数据索引
- (NSInteger)_way0_dataIndexFromUIIndex:(NSInteger)uiIndex {
    /// 利用公式，公式都是推导出来的，理解的不是非常深刻
    NSUInteger ip = uiIndex / MHHorizontalPageSize;
    NSUInteger ii = uiIndex % MHHorizontalPageSize;
    NSUInteger reIndex = (ii % MHHorizontalMaxRow) * MHHorizontalMaxColumn + (ii / MHHorizontalMaxRow);
    uiIndex = reIndex + ip * MHHorizontalPageSize;
    return uiIndex;
}
/// 方式二
- (NSInteger)_way1_dataIndexFromUIIndex:(NSInteger)uiIndex {
    
    /* 水平布局的collectionView显示cell的顺序是:
     * (3x3) 0, 3, 6
     *       1, 4, 7
     *       2, 5, 8
     *
     * 实际一页需要显示的顺序是:
     * (3x3) 0, 1, 2
     *       3, 4, 5
     *       6, 7, 8
     */
    NSArray *map = @[@0, @3, @6, @1, @4, @7, @2, @5, @8];
    /// 这种方式，通过 UI索引 映射出 data索引这种，直观度远远高于方式一，也比较好理解
    return (uiIndex / map.count) * map.count + [map[uiIndex % map.count] integerValue];
}


#pragma mark - MHHorizontalCellDelegate
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSArray *tempArr = self.dataSource[indexPath.section];
    NSInteger dataIndex = [self _transposeToDataIndexFromUIIndex:indexPath.item];
    MHHorizontal *hz = tempArr[dataIndex];
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
#warning CMH : ⚠️ 这里需要交换值，因为是水平滚动。
    flowLayout.minimumLineSpacing = MHHorizontalMinimumInteritemSpacing;
    flowLayout.minimumInteritemSpacing = MHHorizontalMinimumLineSpacing;
    
    CGFloat width = CGFloatPixelRound((MH_SCREEN_WIDTH - 2 * MHHorizontalMinimumInteritemSpacing - 2 * MHHorizontalSectionInset().left)/3.0f);
    CGFloat height = CGFloatPixelRound((MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT - CMHBottomMargin(49) - 2 * MHHorizontalSectionInset().top - 2 * MHHorizontalMinimumLineSpacing)/3.0f);
    
#warning CMH : ⚠️ 这个sectionInset必须是手动算出来的值，而不是直接设置MHHorizontalSectionInset()，且必须算准确，否则布局紊乱
    //    flowLayout.sectionInset = MHHorizontalSectionInset();
    CGFloat insetLeft = (MH_SCREEN_WIDTH - MHHorizontalMaxColumn * width - (MHHorizontalMaxColumn - 1) * flowLayout.minimumLineSpacing )/2.0f;
    CGFloat insetRight = MH_SCREEN_WIDTH - MHHorizontalMaxColumn * width - (MHHorizontalMaxColumn - 1) * flowLayout.minimumLineSpacing - insetLeft;
    CGFloat insetTop = (MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT - CMHBottomMargin(49) - MHHorizontalMaxRow * height - (MHHorizontalMaxRow -1) * MHHorizontalMinimumLineSpacing)/2.0f;
    CGFloat insetBottom = MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT - CMHBottomMargin(49) - MHHorizontalMaxRow * height - (MHHorizontalMaxRow -1) * MHHorizontalMinimumLineSpacing - insetTop;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(insetTop, insetLeft, insetBottom, insetRight);
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
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
    [collectionView registerClass:[MHHorizontalEmptyCell class] forCellWithReuseIdentifier:NSStringFromClass(MHHorizontalEmptyCell.class)];
}

/// 布局子控件
- (void)_makeSubViewsConstraints{}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

@end


