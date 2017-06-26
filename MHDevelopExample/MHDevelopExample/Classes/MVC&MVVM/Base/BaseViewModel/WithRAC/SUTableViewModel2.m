//
//  SUTableViewModel2.m
//  SenbaUsed
//
//  Created by senba on 2017/4/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的控制器有TableView的所有自定义ViewModel的父类

#import "SUTableViewModel2.h"

@interface SUTableViewModel2 ()

@property (nonatomic, strong, readwrite) RACCommand *requestRemoteDataCommand;

@end

@implementation SUTableViewModel2

- (void)initialize {
    [super initialize];
    
    self.page = 1;
    self.lastPage = 1;
    self.perPage = 100;
    
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
    }];
    
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

/// sub class can ovrride it
- (BOOL (^)(NSError *error))requestRemoteDataErrorsFilter {
    return ^(NSError *error) {
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

- (NSUInteger)offsetForPage:(NSUInteger)page {
    return (page - 1) * self.perPage;
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    return [RACSignal empty];
}

@end
