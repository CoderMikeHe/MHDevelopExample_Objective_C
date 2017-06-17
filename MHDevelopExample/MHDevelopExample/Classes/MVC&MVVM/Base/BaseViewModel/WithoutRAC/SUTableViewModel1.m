//
//  SUTableViewModel1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的控制器有TableView的所有自定义ViewModel的父类

#import "SUTableViewModel1.h"

@interface SUTableViewModel1 ()

@end

@implementation SUTableViewModel1

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        _page = 1;
        _perPage = 20;
        _lastPage = 1;
    }
    return self;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - sub class can ovrride it 
/// 加载数据
- (void)loadData:(void(^)(id json))success
         failure:(void(^)(NSError *error))failure
    configFooter:(void(^)(BOOL isLastPage))configFooter {
    // 子类重载
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}
@end
