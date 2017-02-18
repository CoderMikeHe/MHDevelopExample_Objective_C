//
//  MHYouKuAnthologyHeaderView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuAnthologyHeaderView.h"
#import "MHTitleLeftButton.h"
#import "MHYouKuAnthologyItem.h"

static NSString * const reuseIdentifier = @"AnthologyCell";

@interface JLAnthologyCell : UICollectionViewCell

/** 选集 */
@property (nonatomic , strong) MHYouKuAnthology *anthology;

@end


@interface JLAnthologyCell ()

/** 数字 */
@property (nonatomic , weak) UILabel *numLabel;


@end

@implementation JLAnthologyCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.numLabel.textColor = selected?MHGlobalOrangeTextColor:MHGlobalBlackTextColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}
#pragma mark - 公共方法
- (void)setAnthology:(MHYouKuAnthology *)anthology
{
    _anthology = anthology;
    
    self.numLabel.text = [NSString stringWithFormat:@"%zd",anthology.albums_sort];
    
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = MHColor(233, 238, 243);
    self.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = MHColor(239, 240, 242);
    self.selectedBackgroundView = selectedBackgroundView;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 选集
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = MHGlobalBlackTextColor;
    numLabel.font = MHFont(MHPxConvertPt(15.0f), NO);
    self.numLabel = numLabel;
    [self.contentView addSubview:numLabel];
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    
    
}


@end


@interface MHYouKuAnthologyHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

/** titleView */
@property (nonatomic , weak) UIView *titleView;
/** 标识View */
@property (nonatomic , weak) UIView *flagView;
/** 选集 */
@property (nonatomic , weak) UILabel *anthologyLabel;
/** 更多 */
@property (nonatomic , weak) MHTitleLeftButton *moreBtn;

/** collectionView **/
@property (nonatomic , weak) UICollectionView *collectionView;

/** 记录上一次选中 */
@property(nonatomic , weak) NSIndexPath *lastSelectedIndexPath;

/** 第一次加载 */
@property (nonatomic , assign , getter = isFirstLoad) BOOL firstLoad;

/** 分割线 */
@property (nonatomic , weak) MHDivider *bottomSeparate ;

@end



@implementation MHYouKuAnthologyHeaderView

+ (instancetype)anthologyHeaderView
{
    return [[self alloc] init];
}


+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnthologyHeader";
    MHYouKuAnthologyHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        // 缓存池中没有, 自己创建
        header = [[self alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 公共方法
- (void)setAnthologyItem:(MHYouKuAnthologyItem *)anthologyItem
{
    _anthologyItem = anthologyItem;
    
    self.anthologyLabel.text = anthologyItem.title;
    
    [self.collectionView reloadData];
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _firstLoad = YES;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 主题View
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    self.titleView = titleView;
    [self.contentView addSubview:titleView];
    
    // 标注
    UIView *flagView = [[UIView alloc] init];
    flagView.backgroundColor = MHGlobalOrangeTextColor;
    self.flagView = flagView;
    [titleView addSubview:flagView];
    self.flagView = flagView;
    
    // 选集
    UILabel *anthologyLabel = [[UILabel alloc] init];
    anthologyLabel.textAlignment = NSTextAlignmentLeft;
    anthologyLabel.textColor = MHGlobalBlackTextColor;
    anthologyLabel.font = MHFont(MHPxConvertPt(15.0f), NO);
    self.anthologyLabel = anthologyLabel;
    [titleView addSubview:anthologyLabel];
    
    // 更多
    MHTitleLeftButton *moreBtn = [[MHTitleLeftButton alloc] init];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateNormal];
    [moreBtn setTitleColor:MHGlobalGrayTextColor forState:UIControlStateHighlighted];
    [moreBtn setImage:[UIImage imageNamed:@"playerRecommend_rightArrow"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = MHMediumFont(MHPxConvertPt(12.0f));
    [moreBtn addTarget:self action:@selector(_moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.contentView addSubview:collectionView];
    
    //1.注册一定要注册，不注册会崩溃
    [collectionView registerClass:[JLAnthologyCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 分割线
    MHDivider *bottomSeparate = [MHDivider divider];
    bottomSeparate.backgroundColor = MHColorFromHexString(@"#eeeeee");
    self.bottomSeparate = bottomSeparate;
    [self addSubview:bottomSeparate];
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局titleView
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(MHRecommendTitleViewHeight);
    }];
    
    
    // 布局flagView
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView).with.offset(MHGlobalViewLeftInset);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(16.0f);
        make.centerY.equalTo(self.titleView);
    }];
    
    // 布局选集
    [self.anthologyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagView.mas_right).with.offset(6);
        make.top.and.bottom.equalTo(self.titleView);
        make.right.equalTo(self.moreBtn.mas_left);
    }];
    
    // 布局更多
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleView.mas_right);
        make.height.equalTo(self.anthologyLabel.mas_height);
        make.width.mas_equalTo(50.0f);
        make.centerY.equalTo(self.titleView.mas_centerY);
        
    }];

    
    // 布局collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(MHRecommendAnthologyViewHeight);
        make.bottom.equalTo(self.bottomSeparate.mas_top).with.offset(-5.0f);
    }];
    
    // 布局分割线
    [self.bottomSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0.0f);
        
    }];
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局子控件
    
    
}




#pragma mark - 事假处理
/** 更所按钮事件 */
- (void)_moreBtnClicked:(MHTitleLeftButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(anthologyHeaderViewForMoreButtonAction:)]) {
        [self.delegate anthologyHeaderViewForMoreButtonAction:self];
    }
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.anthologyItem.anthologys.count;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JLAnthologyCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.anthology = self.anthologyItem.anthologys[indexPath.item];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 记录选中的Item
    self.anthologyItem.item = indexPath.item;
    
    // 取消上一次的选中
    if (self.lastSelectedIndexPath != indexPath)
    {
        // 选中不是同一个cell
        // 获取上一次的选中的cell
        JLAnthologyCell *lastCell = (JLAnthologyCell *)[collectionView cellForItemAtIndexPath:self.lastSelectedIndexPath];
        // 取消当前的cell
        lastCell.selected = NO;
        // 记录当前的选中
        self.lastSelectedIndexPath = indexPath;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(anthologyHeaderView:mediaBaseId:)]) {
            MHYouKuAnthology *anthology = self.anthologyItem.anthologys[indexPath.item];
            [self.delegate anthologyHeaderView:self mediaBaseId:anthology.mediabase_id];
            
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 第一次加载滚动到指定位置
    if (self.isFirstLoad) {
        
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.anthologyItem.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        self.firstLoad = NO;
    }
    
    if (indexPath.item == self.anthologyItem.item) {
        
        cell.selected = YES;
        self.lastSelectedIndexPath = indexPath;
        
    }else{
        cell.selected = NO;
    }
}





//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = UIEdgeInsetsMake(0, 3, 0, 3);
    return top;
}

//设置水平之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

//设置垂直之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = MHRecommendAnthologyViewHeight;
    return CGSizeMake(width, width);
}

@end
