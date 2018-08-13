//
//  CMHProfileViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHProfileViewController.h"
#import "CMHExampleCell.h"
#import "CMHExample.h"
#import "CMHProfileButton.h"
#import "CMHNavigationController.h"
#import "CMHWebViewController.h"
#import "CMHExample35ViewController.h"
@interface CMHProfileViewController ()

@end

@implementation CMHProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

- (void)configure{
    [super configure];
    
    /// PS: 这里笔者就 统一用 CMHWebViewController , 但是现实中，大多数是 CMHWebViewController 的子类，这里介绍 CMHWebViewController.h 提供的属性的场景
    /// 现实中，你只要组合笔者提供的属性，就会达到满足不同的开发场景，当然你有好的点子，也可以联系笔者哦
    NSString *requestUrl = CMHMyBlogHomepageUrl;
    
    @weakify(self);
    
    
    /// 配置一些数据 <测试代码>
    CMHExample *example30 = [[CMHExample alloc] initWithTitle:@"30：Web默认情况" subtitle:@"有关闭按钮，self.title = webView.title，无下拉刷新"];
    example30.operation = ^{
        @strongify(self);
        CMHWebViewController *webView = [[CMHWebViewController alloc] initWithParams:@{CMHViewControllerRequestUrlKey:requestUrl}];
        [self.navigationController pushViewController:webView animated:YES];
       
    };
    [self.dataSource addObject:example30];
    
    
    CMHExample *example31 = [[CMHExample alloc] initWithTitle:@"31：self.title 不等于 webView.title" subtitle:@"shouldDisableWebViewTitle = YES"];
    example31.operation = ^{
        @strongify(self);
        CMHWebViewController *webView = [[CMHWebViewController alloc] initWithParams:@{CMHViewControllerRequestUrlKey:requestUrl}];
        /// 让导航栏的title不等于WebViewTitle
        webView.shouldDisableWebViewTitle = YES;
        webView.title = @"自定义Title";
        [self.navigationController pushViewController:webView animated:YES];
        
    };
    [self.dataSource addObject:example31];
    
    
    CMHExample *example32 = [[CMHExample alloc] initWithTitle:@"32：取消掉导航栏左侧的关闭按钮" subtitle:@"shouldDisableWebViewClose = YES"];
    example32.operation = ^{
        @strongify(self);
        CMHWebViewController *webView = [[CMHWebViewController alloc] initWithParams:@{CMHViewControllerRequestUrlKey:requestUrl}];
        /// 去掉导航栏左侧的关闭按钮
        webView.shouldDisableWebViewClose = YES;
        [self.navigationController pushViewController:webView animated:YES];
    };
    [self.dataSource addObject:example32];
    
    
    CMHExample *example33 = [[CMHExample alloc] initWithTitle:@"33：支持下拉刷新且一进去就开始刷新" subtitle:@"shouldPullDownToRefresh = YES"];
    example33.operation = ^{
        @strongify(self);
        CMHWebViewController *webView = [[CMHWebViewController alloc] initWithParams:@{CMHViewControllerRequestUrlKey:requestUrl}];
        /// 支持下拉刷新
        webView.shouldPullDownToRefresh = YES;
        [self.navigationController pushViewController:webView animated:YES];
    };
    [self.dataSource addObject:example33];
    
    
    CMHExample *example34 = [[CMHExample alloc] initWithTitle:@"34：支持下拉刷新且一进去不自动刷新" subtitle:@"shouldPullDownToRefresh = YES && shouldBeginRefreshing = NO"];
    example34.operation = ^{
        @strongify(self);
        CMHWebViewController *webView = [[CMHWebViewController alloc] initWithParams:@{CMHViewControllerRequestUrlKey:requestUrl}];
        /// 支持下拉刷新 且 进去不自动刷新
        webView.shouldPullDownToRefresh = YES;
        webView.shouldBeginRefreshing = NO;
        [self.navigationController pushViewController:webView animated:YES];
    };
    [self.dataSource addObject:example34];
    
    /// `contentInset` : 与前面`CMHTableViewController`中的`contentInset`类似，这里就不做复述
    
    
    CMHExample *example35 = [[CMHExample alloc] initWithTitle:@"34：WKWebView系统自带的JS交互" subtitle:@"shouldPullDownToRefresh = YES && shouldBeginRefreshing = NO"];
    example35.operation = ^{
        @strongify(self);
        CMHExample35ViewController *webView = [[CMHExample35ViewController alloc] initWithParams:nil];
        /// 本地资源
        NSString *requestUrl = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        webView.requestUrl = requestUrl;
        webView.localFile = YES;
        [self.navigationController pushViewController:webView animated:YES];
    };
    [self.dataSource addObject:example35];
    
    
    /// 刷洗数据
    //    [self.tableView reloadData]; /// 等效下面的方法
    [self reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 生成一个cell
    return [CMHExampleCell cellWithTableView:tableView];
}

/// 为Cell配置某个
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
    self.navigationItem.title = @"CMHWebViewController";
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
