//
//  SUTableViewModel2.h
//  SenbaUsed
//
//  Created by senba on 2017/4/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的控制器有TableView的所有自定义ViewModel的父类
#import "SUViewModel2.h"

@interface SUTableViewModel2 : SUViewModel2

/// The data source of table view. 这里不能用NSMutableArray，因为NSMutableArray不支持KVO，不能被RACObserve
@property (nonatomic, readwrite, copy) NSArray *dataSource;

/** tableView‘s style defalut is UITableViewStylePlain */
@property (nonatomic, readwrite, assign) UITableViewStyle style;


/** 下来刷新 defalut is NO*/
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/** 上拉加载 defalut is NO*/
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;
/// 是否数据是多段 (It's effect tableView's dataSource 'numberOfSectionsInTableView:') defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldMultiSections;

/// 当前页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger page;
/// 每一页的数据 defalut is 20
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 最后一页 defalut is 1
@property (nonatomic, readwrite, assign) NSUInteger lastPage;


/// 选中命令 eg:  didSelectRowAtIndexPath
@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand;
/// 请求服务器数据的命令
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;

/** fetch the local data */
- (id)fetchLocalData;

/// 请求错误
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

/// 当前页之前的数据
- (NSUInteger)offsetForPage:(NSUInteger)page;

/** request remote data , sub class can override it*/
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;


@end
