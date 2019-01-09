//
//  MHHorizontalMode2Cell0.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/25.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalMode2Cell0.h"
#import "MHHorizontalMode0Cell.h"
#import "MHHorizontalConstant.h"
#import "MHHorizontalGroup.h"
@interface MHHorizontalMode2Cell0 ()<UICollectionViewDelegate,UICollectionViewDataSource,MHHorizontalCellDelegate>

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

@implementation MHHorizontalMode2Cell0

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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHHorizontalMode0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHHorizontalMode0Cell" forIndexPath:indexPath];
    cell.horizontals = self.dataSource[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - MHHorizontalCellDelegate
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell selectedIndex:(NSInteger)selectedIndex{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    MHHorizontal *hz = self.dataSource[indexPath.row][selectedIndex];
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
    flowLayout.itemSize = CGSizeMake(MH_SCREEN_WIDTH, MH_SCREEN_HEIGHT - MH_APPLICATION_TOP_BAR_HEIGHT - CMHBottomMargin(49));
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
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
    [collectionView registerClass:[MHHorizontalMode0Cell class] forCellWithReuseIdentifier:NSStringFromClass(MHHorizontalMode0Cell.class)];
    
}

/// 布局子控件
- (void)_makeSubViewsConstraints{}

/// 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

@end


