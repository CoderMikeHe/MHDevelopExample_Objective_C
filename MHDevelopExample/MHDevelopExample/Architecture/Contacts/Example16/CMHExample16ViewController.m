//
//  CMHExample16ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample16ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"
@interface CMHExample16ViewController ()

@end

@implementation CMHExample16ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 支持上拉加载，下拉刷新
        self.shouldPullDownToRefresh = YES;
        self.shouldPullUpToLoadMore = YES;
        
        /// 是否在用户上拉加载后的数据 , 如果请求回来的数据`小于` pageSize， 则提示没有更多的数据.default is YES 。 如果为`NO` 则隐藏mi_footer 。 前提是` shouldMultiSections = NO `才有效。
        self.shouldEndRefreshingWithNoMoreData = NO; // NO
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

#pragma mark - 事件处理Or辅助方法
- (void)tableViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    self.page = 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// hid HUD
        [MBProgressHUD mh_hideHUDForView:self.view];
        
        /// 清掉数据源
        [self.dataSource removeAllObjects];
        
        /// 模拟数据
        for (NSInteger i = 0; i < self.perPage; i++) {
            NSString *title = [NSString stringWithFormat:@"这是第%ld条优秀数据",(long)i];
            CMHExampleTableTest * et = [[CMHExampleTableTest alloc] init];
            et.idNum = i;
            et.title = title;
            [self.dataSource addObject:et];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
    });
}

- (void)tableViewDidTriggerFooterRefresh{
    /// 下拉加载事件 子类重写
    self.page = self.page + 1;
    
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// hid HUD
        [MBProgressHUD mh_hideHUDForView:self.view];
        
        
        /// 假设第3页的时候请求回来的数据 < self.perPage 模拟网络加载数据不够的情况
        NSInteger count = (self.page >= 3)?18:self.perPage;
        /// 模拟数据
        for (NSInteger i = 0; i < count; i++) {
            NSString *title = [NSString stringWithFormat:@"这是第%ld条优秀数据",(long)(i + (self.page - 1) * self.perPage)];
            CMHExampleTableTest * et = [[CMHExampleTableTest alloc] init];
            et.idNum = i + (self.page - 1) * self.perPage;
            et.title = title;
            [self.dataSource addObject:et];
        }
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self tableViewDidFinishTriggerHeader:NO reload:YES];
        
    });
}



#pragma mark - Override
- (void)configure{
    [super configure];
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
    self.tableView.rowHeight = 55;
    self.title = @"Example16";
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
