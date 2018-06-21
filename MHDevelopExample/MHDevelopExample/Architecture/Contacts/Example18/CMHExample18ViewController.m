//
//  CMHExample18ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/21.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample18ViewController.h"
#import "CMHLiveRoomCell.h"
#import "CMHLiveInfo.h"
@interface CMHExample18ViewController ()

@end

@implementation CMHExample18ViewController
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
#pragma mark - Override
- (void)tableViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"useridx"] = @"61856069";
    subscript[@"type"] = @(1);
    subscript[@"page"] = @(1);
    subscript[@"lat"] = @(22.54192103514200);
    subscript[@"lon"] = @(113.96939828211362);
    subscript[@"province"] = @"广东省";
    
    /// 2. 配置参数模型 #define CMH_GET_LIVE_ROOM_LIST  @"Room/GetHotLive_v2"
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_LIVE_ROOM_LIST parameters:subscript.dictionary];
    
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:CMHLiveRoom.class parsedResult:YES success:^(NSURLSessionDataTask *task, NSArray <CMHLiveRoom *> * responseObject) {
        /// 成功后才设置 self.page = 1;
        self.page = 1;
        /// 添加数据
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObject];
        
        /// 结束刷新状态
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
        /// 配置 EmptyView
        [self.tableView cmh_configEmptyViewWithType:CMHEmptyDataViewTypeDefault emptyInfo:@"客官别急~，一大波小姐姐正在赶来的路上" errorInfo:nil offsetTop:250 hasData:self.dataSource.count>0 hasError:NO reloadBlock:NULL];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
        /// show error
        [MBProgressHUD mh_showErrorTips:error addedToView:self.view];
        
        /// 结束刷新状态
        [self tableViewDidFinishTriggerHeader:YES reload:NO];
        
        /// 配置 EmptyView
        [self.tableView cmh_configEmptyViewWithType:CMHEmptyDataViewTypeDefault emptyInfo:nil errorInfo:[NSError mh_tipsFromError:error] offsetTop:250 hasData:self.dataSource.count>0 hasError:YES reloadBlock:NULL];
    }];
    
}

- (void)tableViewDidTriggerFooterRefresh{
    /// 下拉加载事件 子类重写
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"useridx"] = @"61856069";
    subscript[@"type"] = @(1);
    subscript[@"page"] = @(self.page + 1);
    subscript[@"lat"] = @(22.54192103514200);
    subscript[@"lon"] = @(113.96939828211362);
    subscript[@"province"] = @"广东省";
    
    /// 2. 配置参数模型 #define CMH_GET_LIVE_ROOM_LIST  @"Room/GetHotLive_v2"
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_LIVE_ROOM_LIST parameters:subscript.dictionary];
    
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:CMHLiveRoom.class parsedResult:YES success:^(NSURLSessionDataTask *task, NSArray <CMHLiveRoom *> * responseObject) {
        /// 成功后才设置 self.page += 1;
        self.page += 1;
        /// 添加数据集
        [self.dataSource addObjectsFromArray:responseObject];
        /// 结束刷新状态
        [self tableViewDidFinishTriggerHeader:NO reload:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        /// show error
        [MBProgressHUD mh_showErrorTips:error addedToView:self.view];
        /// 结束刷新状态
        [self tableViewDidFinishTriggerHeader:NO reload:NO];
    }];
}


- (void)configure{
    [super configure];
}

/// 生成一个可复用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHLiveRoomCell cellWithTableView:tableView];
}

/// 为Cell配置数据
- (void)configureCell:(CMHLiveRoomCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell configureModel:object];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMHLiveRoom *liveRoom = self.dataSource[indexPath.row];
    CMHViewController *temp = [[CMHViewController alloc] initWithParams:nil];
    temp.title = liveRoom.myname;
    [self.navigationController pushViewController:temp animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMHLiveRoom *liveRoom = self.dataSource[indexPath.row];
    return liveRoom.cellHeight;
}


#pragma mark - 初始化
- (void)_setup{
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.title = @"喵播";
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
