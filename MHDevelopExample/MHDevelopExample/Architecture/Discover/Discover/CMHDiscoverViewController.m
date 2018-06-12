//
//  CMHDiscoverViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHDiscoverViewController.h"
#import "CMHExampleCell.h"
#import "CMHExample.h"
#import "CMHExample20ViewController.h"
#import "CMHExample21ViewController.h"
#import "CMHExample22ViewController.h"
#import "CMHExample23ViewController.h"
@interface CMHDiscoverViewController ()

@end

@implementation CMHDiscoverViewController

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
}
#pragma mark - Override
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}
- (void)configure{
    [super configure];
    
    
    /**
     这里 `CMHCollectionViewController`跟`CMHTableViewController`的API设计的及其类似，使用方法也类似，这里笔者就不再赘述。大家完全可以参照 CMHTableViewController 提供的Demo.
     众所周知，使用 UICollectionView 最重要的是布局<UICollectionViewLayout>. 比如 UICollectionViewFlowLayout。使我们开发中比较常用的布局。当然，我们可以自定义许多布局来完成各自的产品需求。
     所以，笔者着重讲的是布局。
     */
    
    
    /// 配置测试数据
    CMHExample *example20 = [[CMHExample alloc] initWithTitle:@"20：CMHCollectionViewController" subtitle:@"详见`CMHCollectionViewController.h`属性介绍"];
    example20.destClass = [CMHExample20ViewController class];
    [self.dataSource addObject:example20];

    CMHExample *example21 = [[CMHExample alloc] initWithTitle:@"21：CollectionView 左对齐布局" subtitle:@"详见👉UICollectionViewLeftAlignedLayout"];
    @weakify(self);
    example21.operation = ^{
        @strongify(self);
        CMHExample21ViewController *example = [[CMHExample21ViewController alloc] initWithParams:nil];
        [self.navigationController pushViewController:example animated:YES];
        
        @weakify(self);
        example.callback = ^(NSString *keyword) {
            @strongify(self);
            [MBProgressHUD mh_showTips:[NSString stringWithFormat:@"正在搜索%@",keyword] addedToView:self.view];
        };
    };
    [self.dataSource addObject:example21];

    CMHExample *example22 = [[CMHExample alloc] initWithTitle:@"22：CollectionView 瀑布流布局" subtitle:@"详见👉CHTCollectionViewWaterfallLayout"];
    example22.destClass = [CMHExample22ViewController class];
    [self.dataSource addObject:example22];

    CMHExample *example23 = [[CMHExample alloc] initWithTitle:@"23：CollectionView 电影卡片布局" subtitle:@"详见👉XLCardSwitchFlowLayout"];
    example23.destClass = [CMHExample23ViewController class];
    [self.dataSource addObject:example23];
    
    /// 刷洗数据
    //    [self.tableView reloadData]; /// 等效下面的方法
    [self reloadData];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 生成一个cell
    return [CMHExampleCell cellWithTableView:tableView];
}

/// 为Cell配置某个数据
- (void)configureCell:(CMHExampleCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 为cell配置一个数据模型
    [cell configureModel:object];
}
#pragma mark - 事件处理Or辅助方法


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMHExample *example = self.dataSource[indexPath.row];
    
    if (example.operation) {  /// 如果有对应操作，则执行操作，优先级高于 destClass
        /// 执行操作
        example.operation();
        
        return;
    }
    
    if (example.destClass) {
        CMHViewController *destViewController = [[example.destClass alloc] init];
        [self.navigationController pushViewController:destViewController animated:YES];
    }
}


#pragma mark - 初始化
- (void)_setup{
    self.navigationItem.title = @"CMHCollectionViewController";
    self.tableView.rowHeight = 71;
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
