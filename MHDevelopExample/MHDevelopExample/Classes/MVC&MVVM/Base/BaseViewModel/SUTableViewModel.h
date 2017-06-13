//
//  SUTableViewModel.h
//  SenbaUsed
//
//  Created by senba on 2017/4/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  TableViewModel

#import "SUViewModel.h"

@interface SUTableViewModel : SUViewModel

/// The data source of table view.
@property (nonatomic, readwrite, copy) NSArray *dataSource;

/// The list of section titles to display in section index view.
@property (nonatomic, readwrite, copy) NSArray *sectionIndexTitles;

/// 当前页
@property (nonatomic, readwrite, assign) NSUInteger currentPage;
/// 每一页的数据
@property (nonatomic, readwrite, assign) NSUInteger perPage;
/// 最后一页
@property (nonatomic, readwrite, assign) NSUInteger lastPage;


/** 下来刷新 */
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/** 上拉加载 */
@property (nonatomic, readwrite, assign) BOOL shouldPullUpToLoadMore;

@property (nonatomic, readwrite, copy) NSString *keyword;

/** tableView‘s style defalut is UITableViewStylePlain */
@property (nonatomic, readwrite, assign) UITableViewStyle style;

/// 选中命令 eg:  didSelectRowAtIndexPath
@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand;
/// 请求服务器数据的命令
@property (nonatomic, readonly, strong) RACCommand *requestRemoteDataCommand;

/** fetch the local data */
- (id)fetchLocalData;


- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter;

- (NSUInteger)offsetForPage:(NSUInteger)page;

/** request remote data , sub class can override it*/
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;


@end
