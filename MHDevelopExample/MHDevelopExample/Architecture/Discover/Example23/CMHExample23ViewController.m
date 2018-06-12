//
//  CMHExample23ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample23ViewController.h"
#import "XLCardSwitchFlowLayout.h"
#import "CMHCard.h"
#import "CMHCardCell.h"
@interface CMHExample23ViewController ()

/// imageView
@property (nonatomic , readwrite , weak) UIImageView *imageView;
/// 是否分页，默认为true
@property (nonatomic , readwrite , assign) BOOL pagingEnabled;
/// 当前选中位置
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@end

@implementation CMHExample23ViewController
{
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}


/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pagingEnabled = YES;
        
        /// create collectionViewLayout
        XLCardSwitchFlowLayout *flowLayout = [[XLCardSwitchFlowLayout alloc] init];
        self.collectionViewLayout = flowLayout;
        
        /// Tips : 这里笔者主要是想表达的是 CMHCollectionViewController 可以实现不同的 布局
        /// 当然，这里代码部分完全是Copy 于 XLCardSwitch.现实开发中开发者只需要用 XLCardSwitch 即可。 其作者的源码 👉 https://github.com/mengxianliang/XLCardSwitch
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
    
    /// 注册Cell
    [self.collectionView registerClass:CMHCardCell.class forCellWithReuseIdentifier:@"CMHCardCell"];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsZero;
}

- (void)configure{
    [super configure];
    /// 配置数据
    CMHCard *card0 = [[CMHCard alloc] init];
    card0.title = @"迪丽热巴";
    card0.imageUrl = @"http://img4.imgtn.bdimg.com/it/u=2460756017,2937785205&fm=27&gp=0.jpg";
    
    CMHCard *card1 = [[CMHCard alloc] init];
    card1.title = @"二哈";
    card1.imageUrl = @"http://img3.imgtn.bdimg.com/it/u=965183317,1784857244&fm=27&gp=0.jpg";
    
    CMHCard *card2 = [[CMHCard alloc] init];
    card2.title = @"动漫";
    card2.imageUrl = @"http://img4.imgtn.bdimg.com/it/u=3796556004,3886443338&fm=27&gp=0.jpg";
    
    CMHCard *card3 = [[CMHCard alloc] init];
    card3.title = @"汽车";
    card3.imageUrl = @"http://img2.imgtn.bdimg.com/it/u=2984990935,4159348043&fm=27&gp=0.jpg";
    
    CMHCard *card4 = [[CMHCard alloc] init];
    card4.title = @"孙悟空";
    card4.imageUrl = @"http://img3.imgtn.bdimg.com/it/u=1344300218,1040337319&fm=27&gp=0.jpg";
    
    CMHCard *card5 = [[CMHCard alloc] init];
    card5.title = @"美女";
    card5.imageUrl = @"http://img5.imgtn.bdimg.com/it/u=1914477842,1074336369&fm=27&gp=0.jpg";
    
    CMHCard *card6 = [[CMHCard alloc] init];
    card6.title = @"模特";
    card6.imageUrl = @"http://img0.imgtn.bdimg.com/it/u=3958320691,3151448931&fm=27&gp=0.jpg";
    
    CMHCard *card7 = [[CMHCard alloc] init];
    card7.title = @"水滴";
    card7.imageUrl = @"http://img3.imgtn.bdimg.com/it/u=3922654918,1195871451&fm=27&gp=0.jpg";
    
    CMHCard *card8 = [[CMHCard alloc] init];
    card8.title = @"冰雪";
    card8.imageUrl = @"http://img5.imgtn.bdimg.com/it/u=2648172021,2116929252&fm=27&gp=0.jpg";
    
    CMHCard *card9 = [[CMHCard alloc] init];
    card9.title = @"卡通";
    card9.imageUrl = @"http://img4.imgtn.bdimg.com/it/u=4266595591,4217592991&fm=27&gp=0.jpg";
    
    [self.dataSource addObject:card0];
    [self.dataSource addObject:card1];
    [self.dataSource addObject:card2];
    [self.dataSource addObject:card3];
    [self.dataSource addObject:card4];
    [self.dataSource addObject:card5];
    [self.dataSource addObject:card6];
    [self.dataSource addObject:card7];
    [self.dataSource addObject:card8];
    [self.dataSource addObject:card9];
    
    [self reloadData];
    /// 初始状态
    self.selectedIndex = 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CMHCardCell" forIndexPath:indexPath];
}

- (void)configureCell:(CMHCardCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell configureModel:object];
}

#pragma mark - 事件处理Or辅助方法
//配置cell居中
- (void)_fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width/20.0f;
    if (_dragStartX - _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX - _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self _scrollToCenter];
}

//滚动到中间
- (void)_scrollToCenter {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self _updateBackgroundImage];
}

- (void)_switchToIndex:(NSInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self _updateBackgroundImage];
}


#pragma mark - UIScrollViewDelegate
//在不使用分页滚动的情况下需要手动计算当前选中位置 -> _selectedIndex
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pagingEnabled) {return;}
    if (!self.collectionView.visibleCells.count) {return;}
    if (!scrollView.isDragging) {return;}
    CGRect currentRect = self.collectionView.bounds;
    currentRect.origin.x = self.collectionView.contentOffset.x;
    for (CMHCardCell *cardCell in self.collectionView.visibleCells) {
        if (CGRectContainsRect(currentRect, cardCell.frame)) {
            NSInteger index = [self.collectionView indexPathForCell:cardCell].item;
            if (index != _selectedIndex) {
                _selectedIndex = index;
            }
        }
    }
}

// 手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

// 手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _fixCellToCenter];
    });
}

//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self _scrollToCenter];
}


/// 更新图片
- (void)_updateBackgroundImage{
    CMHCard *card = self.dataSource[self.selectedIndex];
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:card.imageUrl] placeholder:MHImageNamed(@"placeholder_image") options:MHWebImageOptionAutomatic completion:NULL];
}

#pragma mark - UICollectionDelegate

#pragma mark - 初始化
- (void)_setup{
    self.title = @"电影卡片";
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    self.collectionView.showsHorizontalScrollIndicator = false;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    /// 背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    /// 高斯模糊
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.imageView.bounds;
    [self.imageView addSubview:effectView];
    
    [self.view bringSubviewToFront:self.collectionView];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self _switchToIndex:selectedIndex animated:false];
}




@end
