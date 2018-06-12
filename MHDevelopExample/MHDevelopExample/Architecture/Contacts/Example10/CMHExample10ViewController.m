//
//  CMHExample10ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample10ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"

@interface CMHExample10ViewController ()

@end

@implementation CMHExample10ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 默认情况 <基类自带一个全屏幕的tableView，且懒加载了一个数据源 dataSource >
        /// 详见CMHTableViewController.h 头文件
        

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
}

#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 如果是静态数据，在这里配置即可
//    [self _dealwithData];
//    [self reloadData];
}

/// 请求远程数据
- (void)requestRemoteData{
    
    /// 模拟网络
    /// show hud
    [MBProgressHUD mh_showProgressHUD:@"Loading..." addedToView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// hid hud
        [MBProgressHUD mh_hideHUDForView:self.view];
        
        /// 处理数据
        [self _dealwithData];
        
        /// 刷新数据 等效于 [self.tableView reloadData];
        [self reloadData];
    });
}

/// 生成一个可复用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHExampleTableTestCell cellWithTableView:tableView];
}

/// 为Cell配置数据
- (void)configureCell:(CMHExampleTableTestCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell setIndexPath:indexPath rowsInSection:self.dataSource.count];
    [cell configureModel:object];
}


#pragma mark - 事件处理Or辅助方法
- (void)_dealwithData{
    
    for (NSInteger i = 0; i < self.perPage; i++) {
        NSString *title = [NSString stringWithFormat:@"这是第%ld条优秀数据",(long)i];
        CMHExampleTableTest * et = [[CMHExampleTableTest alloc] init];
        et.idNum = i;
        et.title = title;
        [self.dataSource addObject:et];
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMHExampleTableTest *et = self.dataSource[indexPath.row];
    CMHViewController *temp = [[CMHViewController alloc] initWithParams:nil];
    temp.title = [NSString stringWithFormat:@"第%ld条数据",et.idNum];
    [self.navigationController pushViewController:temp animated:YES];
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example10";
    self.tableView.rowHeight = 55;
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
