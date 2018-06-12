//
//  CMHExample22ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample22ViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "CMHWaterfall.h"
#import "CMHWaterfallCell.h"
#import "CMHWaterfallDetailViewController.h"
/// cell
static NSString * const CMHCollectionViewCellReuseIdentifier = @"CMHCollectionViewCellReuseIdentifier";
/// header
static NSString * const CMHSectionHeaderReuseIdentifier      = @"CMHSectionHeaderReuseIdentifier";
/// footer
static NSString * const CMHSectionFooterReuseIdentifier      = @"CMHSectionFooterReuseIdentifier";

@interface CMHExample22ViewController ()<CHTCollectionViewDelegateWaterfallLayout>
/// temps
@property (nonatomic , readwrite , strong) NSMutableArray *temps;
@end

@implementation CMHExample22ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// create collectionViewLayout
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.headerHeight = 0;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        self.collectionViewLayout = layout;
        
        self.perPage = 10;
        
        /// 支持上下拉加载和刷新
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
        
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
    
    /// 注册cell
    [self.collectionView registerClass:[CMHWaterfallCell class]
       forCellWithReuseIdentifier:CMHCollectionViewCellReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
              withReuseIdentifier:CMHSectionHeaderReuseIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
              withReuseIdentifier:CMHSectionFooterReuseIdentifier];
}

#pragma mark - Override
- (void)configure{
    [super configure];
    
    CMHWaterfall *wf0 = [[CMHWaterfall alloc] init];
    wf0.title = @"吴亦凡";
    wf0.imageUrl = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=128966981,3705106937&fm=27&gp=0.jpg";
    wf0.width = 700;
    wf0.height = 1244;
    
    
    CMHWaterfall *wf1 = [[CMHWaterfall alloc] init];
    wf1.title = @"吴亦凡";
    wf1.imageUrl = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2300701076,252080396&fm=27&gp=0.jpg";
    wf1.width = 720;
    wf1.height = 500;
    
    
    CMHWaterfall *wf2 = [[CMHWaterfall alloc] init];
    wf2.title = @"吴亦凡";
    wf2.imageUrl = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3980341606,1588462260&fm=27&gp=0.jpg";
    wf2.width = 1920;
    wf2.height = 1200;
    
    
    CMHWaterfall *wf3 = [[CMHWaterfall alloc] init];
    wf3.title = @"吴亦凡";
    wf3.imageUrl = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=919182151,1088530385&fm=27&gp=0.jpg";
    wf3.width = 1200;
    wf3.height = 2130;
    
    CMHWaterfall *wf4 = [[CMHWaterfall alloc] init];
    wf4.title = @"鹿晗";
    wf4.imageUrl = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=991701608,3109991055&fm=27&gp=0.jpg";
    wf4.width = 540;
    wf4.height = 756;
    
    
    CMHWaterfall *wf5 = [[CMHWaterfall alloc] init];
    wf5.title = @"鹿晗";
    wf5.imageUrl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1310959752,4145237039&fm=27&gp=0.jpg";
    wf5.width = 720;
    wf5.height = 450;
    
    
    CMHWaterfall *wf6 = [[CMHWaterfall alloc] init];
    wf6.title = @"鹿晗";
    wf6.imageUrl = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3671013592,2524205206&fm=27&gp=0.jpg";
    wf6.width = 1366;
    wf6.height = 768;
    

    CMHWaterfall *wf7 = [[CMHWaterfall alloc] init];
    wf7.title = @"迪丽热巴";
    wf7.imageUrl = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3627469057,1481947181&fm=27&gp=0.jpg";
    wf7.width = 1777;
    wf7.height = 1000;
    
    
    CMHWaterfall *wf8 = [[CMHWaterfall alloc] init];
    wf8.title = @"迪丽热巴";
    wf8.imageUrl = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=280169289,4186753272&fm=11&gp=0.jpg";
    wf8.width = 613;
    wf8.height = 523;
    
    
    CMHWaterfall *wf9 = [[CMHWaterfall alloc] init];
    wf9.title = @"杨幂";
    wf9.imageUrl = @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2134095636,3035683221&fm=27&gp=0.jpg";
    wf9.width = 1600;
    wf9.height = 1280;
    
    
    CMHWaterfall *wf10= [[CMHWaterfall alloc] init];
    wf10.title = @"杨幂";
    wf10.imageUrl = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3973257853,2115016827&fm=27&gp=0.jpg";
    wf10.width = 1200;
    wf10.height = 1844;
    
    
    [self.temps addObject:wf0];
    [self.temps addObject:wf1];
    [self.temps addObject:wf2];
    [self.temps addObject:wf3];
    [self.temps addObject:wf4];
    [self.temps addObject:wf5];
    [self.temps addObject:wf6];
    [self.temps addObject:wf7];
    [self.temps addObject:wf8];
    [self.temps addObject:wf9];
    [self.temps addObject:wf10];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:CMHCollectionViewCellReuseIdentifier forIndexPath:indexPath];
}

- (void)configureCell:(CMHWaterfallCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell configureModel:object];
}

- (void)collectionViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    self.page = 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// 清掉数据源
        [self.dataSource removeAllObjects];
        
        /// 模拟数据
        for (NSInteger i = 0; i < self.perPage; i++) {
            [self.dataSource addObject:self.temps[[NSObject mh_randomNumber:0 to:10]]];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self collectionViewDidFinishTriggerHeader:YES reload:YES];
        
    });
}

- (void)collectionViewDidTriggerFooterRefresh{
    /// 下拉加载事件 子类重写
    self.page = self.page + 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// 模拟数据
        /// 假设第3页的时候请求回来的数据 < self.perPage 模拟网络加载数据不够的情况
        NSInteger count = (self.page >= 4)?18:self.perPage;
        
        for (NSInteger i = 0; i < count; i++) {
            [self.dataSource addObject:self.temps[[NSObject mh_randomNumber:0 to:10]]];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self collectionViewDidFinishTriggerHeader:NO reload:YES];
        
    });
}




#pragma mark - 事件处理Or辅助方法

#pragma mark - UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:CMHSectionHeaderReuseIdentifier
                                                                 forIndexPath:indexPath];
        
    }else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:CMHSectionFooterReuseIdentifier
                                                                 forIndexPath:indexPath];
    }
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CMHWaterfall *waterfall = self.dataSource[indexPath.item];    CMHWaterfallDetailViewController *detail = [[CMHWaterfallDetailViewController alloc] initWithParams:@{CMHViewControllerUtilKey:waterfall}];
    [self.navigationController pushViewController:detail animated:YES];
    
}
#pragma mark - CHTCollectionViewDelegateWaterfallLayout
/// 子类必须override
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CMHWaterfall *waterfall = self.dataSource[indexPath.item];
    
    CGFloat width = (MH_SCREEN_WIDTH - (2 - 1) * 10 - 2 * 15)/2;
    
    CGFloat height = width * waterfall.height / waterfall.width;
    
    return CGSizeMake(width, height);
}



#pragma mark - 初始化
- (void)_setup{
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.title = @"瀑布流";
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter
- (NSMutableArray *)temps{
    if (_temps == nil) {
        _temps  = [[NSMutableArray alloc] init];
    }
    return _temps ;
}
@end
