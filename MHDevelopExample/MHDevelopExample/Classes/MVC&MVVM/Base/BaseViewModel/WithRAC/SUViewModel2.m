//
//  SUViewModel2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  

#import "SUViewModel2.h"

@interface SUViewModel2 ()
/**
 * The `params` parameter in `-initWithParams:` method.
 */
@property (nonatomic, readwrite, copy) NSDictionary *params;


// ============== CoderMikeHe =================
@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;
// ============== CoderMikeHe =================
@end

@implementation SUViewModel2

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.params = params;
        self.title = params[SUViewModelTitleKey];
        
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}


/// when `BaseViewModel` created and call `initWithParams` method , so we can ` initialize `
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SUViewModel2 *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithParams:)]
    	subscribeNext:^(id x) {
            @strongify(viewModel)
            [viewModel initialize];
        }];
    
    return viewModel;
}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

/// sub class can override
- (void)initialize {}


@end
