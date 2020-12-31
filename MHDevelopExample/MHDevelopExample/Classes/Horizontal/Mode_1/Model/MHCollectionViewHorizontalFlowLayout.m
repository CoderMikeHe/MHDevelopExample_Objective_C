//
//  MHCollectionViewHorizontalFlowLayout.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/27.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  横向滚动，水平布局


#import "MHCollectionViewHorizontalFlowLayout.h"

@interface MHCollectionViewHorizontalFlowLayout ()

/// 总页数 默认0
@property (nonatomic, readwrite, assign) NSInteger totalPageCount;

/// 每一个section 的起始页索引 数组
@property (nonatomic, readwrite, strong) NSMutableArray *sectionHomepageIndexs;

/// 每一个section 的总页数 数组
@property (nonatomic, readwrite, strong) NSMutableArray *sectionPageCounts;

/// pageSize = rowCount x columnCount
@property (nonatomic, readwrite, assign) NSInteger pageSize;

///
@property (nonatomic, readwrite, strong) NSMutableArray *attributesM;

@end


@implementation MHCollectionViewHorizontalFlowLayout

/// 取floor值
static CGFloat MHFloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _rowCount = 1;
    _columnCount = 1;
}


#pragma mark - Override
/// CollectionView会在初次布局时首先调用该方法
/// CollectionView会在布局失效后、重新查询布局之前调用此方法
/// 子类中必须重写该方法并调用父类的方法
- (void)prepareLayout{
    [super prepareLayout];
    
    /// reset data
    [self.attributesM removeAllObjects];
    [self.sectionPageCounts removeAllObjects];
    [self.sectionHomepageIndexs removeAllObjects];
    self.totalPageCount = 0;
    
    /// 0. 获取所有section
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {  /// 容错
        return;
    }
    
    /// 你若敢瞎传负数或0 我就Crash
    NSAssert(self.columnCount > 0 , @"MHCollectionViewHorizontalFlowLayout columnCount should be greater than 0");
    NSAssert(self.rowCount > 0 , @"MHCollectionViewHorizontalFlowLayout rowCount should be greater than 0");
    
    /// pageSize
    self.pageSize = self.rowCount * self.columnCount;
    
    /// 1. 计算
    /// 起始索引
    NSInteger homepageIndex = 0;
    for (NSInteger section = 0; section < numberOfSections; section++) {
        
        /// 每段总item数
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        /// 记录索引
        [self.sectionHomepageIndexs addObject:@(homepageIndex)];
        
        /// 计算分页总数公式： pageCount = (totalrecords + pageSize - 1) / pageSize
        /// 取得所有该section的总页数
        NSInteger pageCount = (numberOfItems + self.pageSize - 1)/self.pageSize;
        
        /// 记录每段总页数
        [self.sectionPageCounts addObject:@(pageCount)];
        
        /// 计算总页数
        self.totalPageCount += pageCount;
        
        /// 索引自增 pageCount
        homepageIndex += pageCount;
        
        /// 计算所有 item的布局属性
        for (NSInteger idx = 0; idx < numberOfItems; idx++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            UICollectionViewLayoutAttributes *arr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesM addObject:arr];
        }
    }
}


/// 子类必须重写此方法。
/// 并使用它来返回CollectionView视图内容的宽高，
/// 这个值代表的是所有的内容的宽高，并不是当前可见的部分。
/// CollectionView将会使用该值配置内容的大小来促进滚动。
- (CGSize)collectionViewContentSize{
    CGFloat width = self.totalPageCount * self.collectionView.bounds.size.width;
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

/// 返回UICollectionViewLayoutAttributes 类型的数组，
/// UICollectionViewLayoutAttributes 对象包含cell或view的布局信息。
/// 子类必须重载该方法，并返回该区域内所有元素的布局信息，包括cell,追加视图和装饰视图。
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesM;
}

/// 返回指定indexPath的item的布局信息。子类必须重载该方法,该方法
/// 只能为cell提供布局信息，不能为补充视图和装饰视图提供。
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
     * 1. Get section-specific metrics (minimumInteritemSpacing,minimumLineSpacing, sectionInset)
     */
    CGFloat minimumInteritemSpacing = [self _evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat minimumLineSpacing = [self _evaluatedMinimumLineSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets sectionInset = [self _evaluatedSectionInsetForItemAtIndex:indexPath.section];
    
    /// collectionView 宽和高
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = self.collectionView.bounds.size.height;
    
    /// 内容显示的 宽和高
    CGFloat contentW = width - sectionInset.left - sectionInset.right;
    CGFloat contentH = height - sectionInset.top - sectionInset.bottom;
    
    /// 这里假设每个item是等宽和等高的
    CGFloat itemW = MHFloorCGFloat((contentW - (self.columnCount - 1) * minimumInteritemSpacing)/self.columnCount);
    CGFloat itemH = MHFloorCGFloat((contentH - (self.rowCount - 1) * minimumLineSpacing)/self.rowCount);
    
    /// 当前Section的当前页
    NSInteger currentPage = indexPath.item / self.pageSize;
    /// 当前section的起始页X
    CGFloat sectionHomepageX = [self.sectionHomepageIndexs[indexPath.section] integerValue] * width;
    
    /// 计算 item 的 X 和 Y
    CGFloat itemX = sectionInset.left + (itemW + minimumInteritemSpacing) * (indexPath.item % self.columnCount) + currentPage * width;
    itemX = sectionHomepageX + itemX;
    
    CGFloat itemY = sectionInset.top + (itemH + minimumLineSpacing) * ((indexPath.item - self.pageSize * currentPage) / self.columnCount);
    
    /// 获取原布局
    UICollectionViewLayoutAttributes* attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    /// 更新布局
    attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
    return attributes;
}

#pragma mark - Private Method
- (CGFloat)_evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (CGFloat)_evaluatedMinimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }else{
        return self.minimumLineSpacing;
    }
}

- (UIEdgeInsets)_evaluatedSectionInsetForItemAtIndex:(NSInteger)section{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}
#pragma mark - Setter & Getter
- (void)setRowCount:(NSInteger)rowCount{
    if (_rowCount != rowCount) {
        _rowCount = rowCount;
        [self invalidateLayout];
    }
}

- (void)setColumnCount:(NSInteger)columnCount{
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (NSMutableArray *)sectionPageCounts{
    if (_sectionPageCounts == nil) {
        _sectionPageCounts = [[NSMutableArray alloc] init];
    }
    return _sectionPageCounts;
}

- (NSMutableArray *)sectionHomepageIndexs{
    if (_sectionHomepageIndexs == nil) {
        _sectionHomepageIndexs = [[NSMutableArray alloc] init];
    }
    return _sectionHomepageIndexs;
}

- (NSMutableArray *)attributesM{
    if (_attributesM == nil) {
        _attributesM = [[NSMutableArray alloc] init];
    }
    return _attributesM;
}

- (id <UICollectionViewDelegateFlowLayout> )delegate {
    return (id <UICollectionViewDelegateFlowLayout> )self.collectionView.delegate;
}


@end
