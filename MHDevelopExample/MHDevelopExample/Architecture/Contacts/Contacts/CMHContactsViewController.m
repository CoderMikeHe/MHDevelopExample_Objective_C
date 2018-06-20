//
//  CMHContactsViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHContactsViewController.h"
#import "CMHExampleCell.h"
#import "CMHExample.h"
#import "CMHExample10ViewController.h"
#import "CMHExample11ViewController.h"
#import "CMHExample12ViewController.h"
#import "CMHExample13ViewController.h"
#import "CMHExample14ViewController.h"
#import "CMHExample15ViewController.h"
#import "CMHExample16ViewController.h"
#import "CMHExample17ViewController.h"
@interface CMHContactsViewController ()

@end

@implementation CMHContactsViewController

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
    
    /// 配置测试数据
    CMHExample *example10 = [[CMHExample alloc] initWithTitle:@"10：CMHTableViewController 默认配置" subtitle:@"详见`CMHTableViewController.h`属性介绍"];
    example10.destClass = [CMHExample10ViewController class];
    [self.dataSource addObject:example10];
    
    CMHExample *example11 = [[CMHExample alloc] initWithTitle:@"11：TableView的样式" subtitle:@"style = UITableViewStyleGrouped"];
    example11.destClass = [CMHExample11ViewController class];
    [self.dataSource addObject:example11];
    
    CMHExample *example12 = [[CMHExample alloc] initWithTitle:@"12：设置contentInset属性" subtitle:@"重写contentInset方法，配置其具体的值"];
    example12.destClass = [CMHExample12ViewController class];
    [self.dataSource addObject:example12];
    
    CMHExample *example13 = [[CMHExample alloc] initWithTitle:@"13：支持上下拉刷新加载，且自动刷新" subtitle:@"shouldPullDownToRefresh = YES , shouldPullUpToLoadMore = YES"];
    example13.destClass = [CMHExample13ViewController class];
    [self.dataSource addObject:example13];
    
    CMHExample *example14 = [[CMHExample alloc] initWithTitle:@"14：支持上下拉刷新加载，但不自动刷新" subtitle:@"支持上下拉，shouldBeginRefreshing = NO"];
    example14.destClass = [CMHExample14ViewController class];
    [self.dataSource addObject:example14];
    
    
    CMHExample *example15 = [[CMHExample alloc] initWithTitle:@"15：支持多段展示数据" subtitle:@"shouldMultiSections = YES"];
    example15.destClass = [CMHExample15ViewController class];
    [self.dataSource addObject:example15];
    
    
    CMHExample *example16 = [[CMHExample alloc] initWithTitle:@"16：上拉加载数据小于pageSize处理" subtitle:@"shouldEndRefreshingWithNoMoreData = YES Or NO"];
    example16.destClass = [CMHExample16ViewController class];
    [self.dataSource addObject:example16];
    
    CMHExample *example17 = [[CMHExample alloc] initWithTitle:@"17：测试数据源为空显示占位视图" subtitle:@"详情请看`EmptyView`文件夹的内容"];
    example17.destClass = [CMHExample17ViewController class];
    [self.dataSource addObject:example17];
    
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
    self.navigationItem.title = @"CMHTableViewController";
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
