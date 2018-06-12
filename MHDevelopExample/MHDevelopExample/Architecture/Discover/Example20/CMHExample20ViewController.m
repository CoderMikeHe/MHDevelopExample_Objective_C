//
//  CMHExample20ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample20ViewController.h"
#import "CMHExampleCollectTest.h"
#import "CMHExampleCollectTestCell.h"

@interface CMHExample20ViewController ()

@end

@implementation CMHExample20ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 默认情况 <基类自带一个全屏幕的CollectionView，且懒加载了一个数据源 dataSource >
        /// 详见CMHCollectionViewController 头文件
        
        /// 支持上下拉刷新和加载
        self.shouldPullDownToRefresh = YES;
        self.shouldPullUpToLoadMore = YES;
        
        
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
    
    /// 注册一个Cell
    [self.collectionView registerClass:CMHExampleCollectTestCell.class forCellWithReuseIdentifier:@"CMHExampleCollectTestCell"];
}

#pragma mark - Override
- (void)configure{
    [super configure];
    /// 配置数据
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CMHExampleCollectTestCell" forIndexPath:indexPath];
}

- (void)configureCell:(CMHExampleCollectTestCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
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
            NSString *title = [NSString stringWithFormat:@"第%ld条优秀数据",(long)i];
            CMHExampleCollectTest * et = [[CMHExampleCollectTest alloc] init];
            et.idNum = i;
            et.title = title;
            [self.dataSource addObject:et];
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
        NSInteger count = (self.page >= 3)?18:self.perPage;
        
        for (NSInteger i = 0; i < count; i++) {
            NSString *title = [NSString stringWithFormat:@"第%ld条优秀数据",(long)(i + (self.page - 1) * self.perPage)];
            CMHExampleCollectTest * et = [[CMHExampleCollectTest alloc] init];
            et.idNum = i + (self.page - 1) * self.perPage;
            et.title = title;
            [self.dataSource addObject:et];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self collectionViewDidFinishTriggerHeader:NO reload:YES];
        
    });
}


#pragma mark - 事件处理Or辅助方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CMHExampleCollectTest *et = self.dataSource[indexPath.row];
    CMHViewController *temp = [[CMHViewController alloc] initWithParams:nil];
    temp.title = [NSString stringWithFormat:@"第%ld条数据",et.idNum];
    [self.navigationController pushViewController:temp animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /// Item 尺寸 每行三个Item
    CGFloat num = 3;
    CGFloat WH = (MH_SCREEN_WIDTH - (num - 1) * 10 - 20.0f * 2)/num;
    return CGSizeMake(WH, WH);
}
/// 每段的内容显示区域
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(16, 20, 16, 20);
}
/// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

/// 每行内部item的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example20";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
