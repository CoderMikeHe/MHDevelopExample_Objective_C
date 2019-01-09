//
//  MHHorizontalMode1LinkageController.m
//  MHObjectiveC
//
//  Created by CoderMikeHe on 2018/12/14.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  方案二 ： 1个黑块 == 1个Cell，原生UICollectionViewFlowLayout布局，且UIPageControl支持联动

/// 只需要查看以下方法

#import "MHHorizontalMode1LinkageController.h"
#import "MHHorizontalGroup.h"
#import "MHButton.h"
#import "MHHorizontalEmptyCell.h"
#import "MHHorizontalMode1Cell.h"
#import "MHHorizontalConstant.h"

/// 标题额外增加的宽度，默认为 20.0f
static CGFloat const MHTitleAdditionalWidth = 40;

@interface MHHorizontalMode1LinkageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,MHHorizontalCellDelegate>
/// backgroundView
@property (nonatomic, readwrite, weak) UIImageView *backgroundView;
/// titleScrollView
@property (nonatomic, readwrite, weak) UIScrollView *titleScrollView;
/// contentView
@property (nonatomic, readwrite, weak) UICollectionView *contentView;
/// pageControlScrollView
@property (nonatomic, readwrite, weak) UIScrollView *pageControlScrollView;


/// 原始组数据
@property (nonatomic, readwrite, copy) NSArray <MHHorizontalGroup *> *horizontalGroups;
/// dataSource
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
/// 存储标题按钮的数组
@property (nonatomic, readwrite, strong) NSMutableArray *btnMArr;
/// pageControls
@property (nonatomic, readwrite, strong) NSMutableArray *pageControls;

/// page映射表 (page 转 索引)
@property (nonatomic, readwrite, copy) NSDictionary *pageMappingTable;
/// horizontalGroupPageIndexs 每组起始索引
@property (nonatomic, readwrite, copy) NSArray<NSNumber *> *horizontalGroupPageIndexs;;
/// 每组的每页数据
@property (nonatomic, readwrite, copy) NSArray<NSNumber *> *horizontalGroupPageCounts;
/// tempHorizontal
@property (nonatomic, readwrite, strong) MHHorizontal *tempHorizontal;
/// tempBtn
@property (nonatomic, readwrite, strong) UIButton *tempBtn;

/// 标记按钮是否点击
@property (nonatomic, readwrite, assign) BOOL signBtnClick;
/// 标记内容滚动
@property (nonatomic, readwrite, assign) BOOL isScroll;

/// 总页数
@property (nonatomic, readwrite, assign) NSInteger horizontalGroupTotalPageCount;
/// 标记按钮下标
@property (nonatomic, readwrite, assign) NSInteger signBtnIndex;
/// 记录刚开始时的偏移量
@property (nonatomic, readwrite, assign) NSInteger startOffsetX;

/// 开始颜色, 取值范围 0~1
@property (nonatomic, readwrite, assign) CGFloat startR;
@property (nonatomic, readwrite, assign) CGFloat startG;
@property (nonatomic, readwrite, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, readwrite, assign) CGFloat endR;
@property (nonatomic, readwrite, assign) CGFloat endG;
@property (nonatomic, readwrite, assign) CGFloat endB;
@end

@implementation MHHorizontalMode1LinkageController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubviews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
    
    /// 默认点击第一个
    [self _buttonDidClicked:self.btnMArr.firstObject];
}

#pragma mark - 事件处理Or辅助方法
/// 配置数据
- (void)_configureData{
    /// 原始的组数据
    self.horizontalGroups = [MHHorizontalGroup fetchHorizontalGroups];
    /// 记录第一项
    self.tempHorizontal = [[self.horizontalGroups.firstObject horizontals] firstObject];
    /// 总数
    NSInteger groupCount = self.horizontalGroups.count;
    /// 索引
    NSInteger pageIndex = 0;
    /// 索引数组
    NSMutableArray *pageIndexs = [NSMutableArray array];
    /// 页数组
    NSMutableArray *pageCounts = [NSMutableArray array];
    /// mappingTable
    NSMutableDictionary *mappingTable = [NSMutableDictionary dictionary];
    
    /// 配置分页数据
    for (NSInteger g = 0 ; g < groupCount ; g++) {
        
        MHHorizontalGroup *group = self.horizontalGroups[g];
        NSMutableArray *temps = [NSMutableArray array];
        
        /// 计算分页总数公式： pageCount = (totalrecords + pageSize - 1) / pageSize  //取得所有页数
        NSInteger count = group.horizontals.count;
        NSInteger pageCount = (count + MHHorizontalPageSize - 1)/MHHorizontalPageSize;
        
        group.numberOfPages = pageCount;
        
        /// 计算数据
        for (NSInteger page = 0; page < pageCount; page++) {
            /// 计算range
            NSInteger loc = page * MHHorizontalPageSize;
            NSInteger len = (page < (pageCount-1))?MHHorizontalPageSize:(count%MHHorizontalPageSize);
            /// 取出数据
            NSArray *arr = [group.horizontals subarrayWithRange:NSMakeRange(loc, len)];
            
            /// 添加数组
            [temps addObject:arr];
            
            /// 加入page映射表
            [mappingTable setObject:@(g) forKey:@(page+pageIndex)];
        }
        
        /// 添加索引
        [pageIndexs addObject:@(pageIndex)];
        /// 添加页数
        [pageCounts addObject:@(pageCount)];
        
        /// 每组索引增加
        pageIndex += pageCount;
        
        /// 总页数
        self.horizontalGroupTotalPageCount += pageCount;
        
        /// 加入数据源
        [self.dataSource addObjectsFromArray:temps.copy];
    }
    /// 赋值
    self.horizontalGroupPageIndexs = [pageIndexs copy];
    self.horizontalGroupPageCounts = [pageCounts copy];
    self.pageMappingTable = [mappingTable copy];
    /// 刷新数据
    [self.contentView reloadData];
}

/// 按钮点击事件处理
- (void)_buttonDidClicked:(UIButton *)sender{
    /// 改变按钮状态
    [self _changeSelectedButton:sender];
    
    _signBtnClick = YES;
    
    /// 选中按钮居中
    [self _selectedBtnCenter:sender];
    
    /// 滚动内容
    [self _setPageContentViewWithCurrentIndex:sender.tag];
    
    // 标记按钮下标
    _signBtnIndex = sender.tag;
}

- (void)_changeSelectedButton:(UIButton *)button {
    if (self.tempBtn == nil) {
        button.selected = YES;
        self.tempBtn = button;
    } else if (self.tempBtn != nil && self.tempBtn == button){
        button.selected = YES;
    } else if (self.tempBtn != button && self.tempBtn != nil){
        self.tempBtn.selected = NO;
        button.selected = YES;
        self.tempBtn = button;
    }
    // 避免滚动过程中点击标题手指不离开屏幕的前提下再次滚动造成的误差（由于文字渐变效果导致未选中标题的不准确处理）
    [self.btnMArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        btn.titleLabel.textColor = [UIColor whiteColor];
    }];
    button.titleLabel.textColor = [UIColor pinkColor];
}

/// 标题滚动样式下选中标题居中处理
- (void)_selectedBtnCenter:(UIButton *)centerBtn {
    // 计算偏移量
    CGFloat offsetX = centerBtn.center.x - self.view.mh_width * 0.5;
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - self.view.mh_width;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/// 开始颜色设置
- (void)_setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self _getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}
/// 结束颜色设置
- (void)_setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self _getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}
/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)_getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}


/// 改变选中的Item
- (void)_changeSelectedHorizontal:(MHHorizontal *)horizontal {
    if (self.tempHorizontal == nil) {
        horizontal.selected = YES;
        self.tempHorizontal = horizontal;
    } else if (self.tempHorizontal != nil && self.tempHorizontal == horizontal){
        horizontal.selected = YES;
    } else if (self.tempHorizontal != horizontal && self.tempHorizontal != nil){
        self.tempHorizontal.selected = NO;
        horizontal.selected = YES;
        self.tempHorizontal = horizontal;
    }
}

/// 处理pageTitleScrollView
- (void)_setPageTitleScrollViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    // 1、取出 originalBtn、targetBtn
    UIButton *originalBtn = self.btnMArr[originalIndex];
    UIButton *targetBtn = self.btnMArr[targetIndex];
    _signBtnIndex = targetBtn.tag;
    
    if (_signBtnClick == NO) {
        [self _selectedBtnCenter:targetBtn];
    }
    _signBtnClick = NO;
    
    // 改变按钮的选择状态
    if (progress >= 0.8) { /// 此处取 >= 0.8 而不是 1.0 为的是防止用户滚动过快而按钮的选中状态并没有改变
        [self _changeSelectedButton:targetBtn];
    }
    
    [self _setPageTitleGradientEffectWithProgress:progress originalBtn:originalBtn targetBtn:targetBtn];
}

/// pageControlScrollView联动
- (void)_setPageControlScrollViewWithProgress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex{
    /// 设置
    CGFloat offsetX = originalIndex * self.pageControlScrollView.mh_width + (targetIndex - originalIndex) * self.pageControlScrollView.mh_width *progress;
    
    /// 滚动
    [self.pageControlScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}


/// 设置contentView滚动
- (void)_setPageContentViewWithCurrentIndex:(NSInteger)currentIndex{
    /// 滚动contentView
    CGFloat offsetX = [self.horizontalGroupPageIndexs[currentIndex] integerValue] * self.contentView.mh_width;
    _startOffsetX = offsetX;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    /// 更新pageControl
    UIPageControl *pageControl = self.pageControls[currentIndex];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = [self.horizontalGroupPageCounts[currentIndex] integerValue];
    offsetX = currentIndex * self.pageControlScrollView.mh_width;
    [self.pageControlScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

/// 颜色渐变方法抽取
- (void)_setPageTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
    
    /// 容错处理,相同按钮不处理
    if (originalBtn == targetBtn) { return; }
    
    // 获取 targetProgress
    CGFloat targetProgress = progress;
    // 获取 originalProgress
    CGFloat originalProgress = 1 - targetProgress;
    
    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
    UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
    // 设置文字颜色渐变
    originalBtn.titleLabel.textColor = originalColor;
    targetBtn.titleLabel.textColor = targetColor;
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
        if (targetIndex >= self.horizontalGroupTotalPageCount) {
            progress = 1;
            targetIndex = self.horizontalGroupTotalPageCount - 1;
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
        if (originalIndex >= self.horizontalGroupTotalPageCount) {
            originalIndex = self.horizontalGroupTotalPageCount - 1;
        }
    }
    /// 通过page映射表，获取组索引
    NSInteger originalGroupIndex = [[self.pageMappingTable objectForKey:@(originalIndex)] integerValue];
    NSInteger targetGroupIndex = [[self.pageMappingTable objectForKey:@(targetIndex)] integerValue];
    /// 处理PageTitle
    [self _setPageTitleScrollViewWithProgress:progress originalIndex:originalGroupIndex targetIndex:targetGroupIndex];
    
    /// 处理pageControl 滚动
    [self _setPageControlScrollViewWithProgress:progress originalIndex:originalGroupIndex targetIndex:targetGroupIndex];
    
    /// 处理pageControl
    if (progress >= 0.8) {
        ///起始索引
        NSInteger pageIndex = [self.horizontalGroupPageIndexs[targetGroupIndex] integerValue];
        /// 取出pageControl
        UIPageControl *pageControl = self.pageControls[targetGroupIndex];
        pageControl.currentPage = targetIndex - pageIndex;
        pageControl.numberOfPages = [self.horizontalGroups[targetGroupIndex] numberOfPages];
    }
}

#pragma mark - - - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
#warning CMH : ⚠️ 一页就是一个section
    return self.horizontalGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning CMH : ⚠️ 因为是一页就是一段，为保证当前section 不会关联下一个section的数据，这这段必须是 pageSize
    return MHHorizontalPageSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tempArray = self.dataSource[indexPath.section];
    NSInteger count = tempArray.count;
    /// 需要颠倒 transpose row/col
    NSInteger dataIndex = [self _transposeToDataIndexFromUIIndex:indexPath.item];
#warning CMH : ⚠️ 当前段不满 pageSize 的用 emptyCell
    if (dataIndex < count) {
        MHHorizontalMode1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MHHorizontalMode1Cell.class) forIndexPath:indexPath];
        cell.horizontal = tempArray[dataIndex];
        cell.delegate = self;
        return cell;
    }else{
        MHHorizontalEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MHHorizontalEmptyCell.class) forIndexPath:indexPath];
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
    NSIndexPath *indexPath = [self.contentView indexPathForCell:cell];
    NSArray *tempArr = self.dataSource[indexPath.section];
    NSInteger dataIndex = [self _transposeToDataIndexFromUIIndex:indexPath.item];
    MHHorizontal *horizontal = tempArr[dataIndex];
    [self _changeSelectedHorizontal:horizontal];
    /// 刷新数据
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    /// 去掉CollectionView刷新闪烁的Bug
    [UIView performWithoutAnimation:^{
        /// 刷新数据
        [self.contentView reloadSections:indexSet];
    }];
}


#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    /// 配置数据
    [self _configureData];
}

/// 设置导航栏
- (void)_setupNavigationItem{
    self.title = @"方案二(联动)";
}

/// 初始化子控件
- (void)_setupSubviews{
    /// 初始化BgView
    [self _setupBackgroundView];
    
    /// 初始化titleScrollView
    [self _setupTitleScrollView];
    
    /// 创建contentView
    [self _setupContentView];
    
    /// 初始化pageControl
    [self _setupPageControlScrollView];
}

/// 初始化背景View
- (void)_setupBackgroundView{
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = MHImageNamed(@"bg_image");
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
}

/// 初始化titleScrollView
- (void)_setupTitleScrollView{
    
    /// titleScrollView
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = [UIColor blackColor];
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.alwaysBounceHorizontal = YES;
    titleScrollView.bounces = YES;
    [self.view addSubview:titleScrollView];
    self.titleScrollView = titleScrollView;
    
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = 0;
    CGFloat buttonH = MH_APPLICATION_TOOL_BAR_HEIGHT_49;
    
    /// 创建按钮
    NSInteger count = self.horizontalGroups.count;
    for (NSInteger i = 0; i < count; i++) {
        /// 取出组
        MHHorizontalGroup *g = self.horizontalGroups[i];
        /// button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor pinkColor] forState:UIControlStateSelected];
        [button setTitle:g.name forState:UIControlStateNormal];
        button.titleLabel.font = MHRegularFont_16;
        button.tag = i;
        [titleScrollView addSubview:button];
        [button addTarget:self action:@selector(_buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnMArr addObject:button];
        
        /// 计算宽度
        buttonW = [g.name mh_sizeWithFont:button.titleLabel.font].width + MHTitleAdditionalWidth;
        /// 布局
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        buttonX = buttonX + buttonW;
    }
    
    /// 设置contentSize
    CGFloat scrollViewWidth = CGRectGetMaxX(self.titleScrollView.subviews.lastObject.frame);
    self.titleScrollView.contentSize = CGSizeMake(scrollViewWidth, buttonH);
    
    /// 记录颜色 RGB
    [self _setupStartColor:[UIColor whiteColor]];
    [self _setupEndColor:[UIColor pinkColor]];
}


/// 创建contentView
- (void)_setupContentView{
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
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    contentView.backgroundColor = [UIColor clearColor];
    self.contentView = contentView;
    contentView.bounces = NO;
    contentView.pagingEnabled = YES;
    contentView.pagingEnabled = YES;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    
    contentView.delegate = self;
    contentView.dataSource = self;
    
    [self.view addSubview:contentView];
    /// 注册CellID
    [contentView registerClass:[MHHorizontalMode1Cell class] forCellWithReuseIdentifier:NSStringFromClass(MHHorizontalMode1Cell.class)];
    [contentView registerClass:[MHHorizontalEmptyCell class] forCellWithReuseIdentifier:NSStringFromClass(MHHorizontalEmptyCell.class)];
}

/// 创建PageControl scrollView
- (void)_setupPageControlScrollView{
    
    UIScrollView *pageControlScrollView = [[UIScrollView alloc] init];
    pageControlScrollView.backgroundColor = [UIColor clearColor];
    pageControlScrollView.showsVerticalScrollIndicator = NO;
    pageControlScrollView.showsHorizontalScrollIndicator = NO;
    pageControlScrollView.bounces = NO;
    pageControlScrollView.pagingEnabled = YES;
    /// 不支持用户交互
    pageControlScrollView.userInteractionEnabled = NO;
    [self.view addSubview:pageControlScrollView];
    self.pageControlScrollView = pageControlScrollView;
    
    /// 创建子控件 pageControl
    CGFloat pageControlX = 0;
    CGFloat pageControlY = 0;
    CGFloat pageControlW = self.view.frame.size.width;
    CGFloat pageControlH = MHHorizontalSectionInset().bottom;
    
    /// 创建按钮
    NSInteger count = self.horizontalGroups.count;
    
    for (NSInteger i = 0; i < count; i++) {
        /// 取出组
        MHHorizontalGroup *g = self.horizontalGroups[i];
#warning CMH : ⚠️ 必须搞个 中间View来包装pageControl，否则直接将pageControl加到scrollView上显示紊乱
        UIView *tempView = [[UIView alloc] init];
        tempView.backgroundColor = [UIColor clearColor];
        /// 布局
        tempView.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
        [pageControlScrollView addSubview:tempView];
        
        /// pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = tempView.bounds;
        pageControl.userInteractionEnabled = NO;
        pageControl.hidesForSinglePage = YES;
        pageControl.tag = i+100;
        /// 配置数据
        pageControl.numberOfPages = g.numberOfPages;
        pageControl.currentPage = 0;
        [tempView addSubview:pageControl];
        [self.pageControls addObject:pageControl];
        
        /// 记录x
        pageControlX = pageControlX + pageControlW;
    }
    
    /// 设置contentSize
    CGFloat scrollViewWidth = pageControlW * count;
    pageControlScrollView.contentSize = CGSizeMake(scrollViewWidth, 0);
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    /// 布局bgView
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    /// 布局titleScrollView
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(CMHBottomMargin(49));
    }];
    
    /// 布局contentView
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(MH_APPLICATION_TOP_BAR_HEIGHT);
        make.bottom.equalTo(self.titleScrollView.mas_top).with.offset(0);
    }];
    
    /// 布局pageControlScrollView
    [self.pageControlScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(MHHorizontalSectionInset().bottom);
    }];
}

#pragma mark - Getter & Setter
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)btnMArr{
    if (_btnMArr == nil) {
        _btnMArr = [[NSMutableArray alloc] init];
    }
    return _btnMArr;
}

- (NSMutableArray *)pageControls{
    if (_pageControls == nil) {
        _pageControls = [[NSMutableArray alloc] init];
    }
    return _pageControls;
}

@end
