//
//  CMHExample17ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample17ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"
@interface CMHExample17ViewController ()

@end

@implementation CMHExample17ViewController
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
- (void)_shuffle:(UIBarButtonItem *)sender{
    [MBProgressHUD mh_showProgressHUD:@"Loading..." addedToView:self.view];
    [self tableViewDidTriggerHeaderRefresh];
}
#pragma mark - Override
- (void)tableViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    self.page = 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// hid HUD
        [MBProgressHUD mh_hideHUDForView:self.view];
        /// 假设就是没有数据
        
        /// 现实场景中，我们利用AFNetworking访问服务器的数据，有成功的回调，和失败的回调，如下所示。
        /**
         ///
         [CMHHttpRequestTool POST:UFMapListUrl params:params completion:^(NSURLSessionDataTask *task, id responseObject) {
             /// 请求成功的回调
             /// 若code == 200，则代表数据请求成功，否则则代表数据请求失败
             if ([responseObject[@"code"] integerValue]== 200) {
                /// 这里就代表请求成功，但是返回来的数据可能为空
             }else{
                /// 这里一般是服务器的问题，比如 服务器报500的错误，或者404的错误，以及503等等
             }
         } failed:^(NSURLSessionDataTask *task, NSError *error) {
            /// 请求失败的回调，
            /// 客户端一般只需要关心出错的原因是：
            /// - 网络问题
            /// - 服务器问题
         }];
         */
        /// 以下模拟上面的网络请求回调 。 requestState == 0 则代表请求失败，反之，则代表请求成功
        NSInteger requestState = [NSObject mh_randomNumber:0 to:4];
        CMHEmptyDataViewType emptyType = [NSObject mh_randomNumber:0 to:9];
        if (requestState > 0) {
            
            /// 服务器请求成功的返回的状态码 requestCode == 200 则代表有数据 ， 反之则代表服务器出错
            NSInteger requestCode = [NSObject mh_randomNumber:199 to:205];
            
            BOOL hasError = (requestCode < 200);
            
            /// 请求成功的回调
            if (requestCode >= 200) { /// 这里假设>=200代表成功，增加一下模拟成功的几率
                /// 这里就代表请求成功，但是返回来的数据可能为空
            }else{
                /// 这里一般是服务器的问题，比如 服务器报500的错误，或者404的错误，以及503等等
            }
            [self.tableView cmh_configEmptyViewWithType:emptyType emptyInfo:nil errorInfo:nil offsetTop:250 hasData:self.dataSource.count>0 hasError:hasError reloadBlock:NULL];
        }else{
            /// 请求失败的回调，
            /// 客户端一般只需要关心出错的原因是：
            /// - 网络问题
            /// - 服务器问题
            /// 只需要设置 errorInfo 和 hasError == YES , hasData
            @weakify(self);
            [self.tableView cmh_configEmptyViewWithType:emptyType emptyInfo:nil errorInfo:nil offsetTop:250 hasData:self.dataSource.count>0 hasError:YES reloadBlock:^{
                @strongify(self);
                [MBProgressHUD mh_showProgressHUD:@"Loading..." addedToView:self.view];
                [self tableViewDidTriggerHeaderRefresh];
            }];
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
    self.title = @"Example17";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(_shuffle:)];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
