//
//  SUViewModel2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的所有自定义ViewModel的父类

#import "SUViewModel2.h"


//// PS 这里应该有以下外部变量的,但是为了兼容 MVVM Without RAC的设计模式，笔者把其放置在 SUConstant.h/.m中，大家可以去看看。
/**
 ////////////////// MVVM ViewModel Params中的key //////////////////
 /// MVVM View
 /// The base map of 'params'
 /// The `params` parameter in `-initWithParams:` method.
 /// Key-Values's key
 /// 传递唯一ID的key：例如：商品id 用户id...
 NSString *const SUViewModelIDKey = @"SUViewModelIDKey";
 /// 传递导航栏title的key：例如 导航栏的title...
 NSString *const SUViewModelTitleKey = @"SUViewModelTitleKey";
 /// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
 NSString *const SUViewModelUtilKey = @"SUViewModelUtilKey";
 /// 传递webView Request的key：例如 webView request...
 NSString *const SUViewModelRequestKey = @"SUViewModelRequestKey";
 **/


@interface SUViewModel2 ()
/**
 * The `params` parameter in `-initWithParams:` method.
 */
@property (nonatomic, readwrite, copy) NSDictionary *params;
/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readwrite, strong) RACSubject *errors;

@end

@implementation SUViewModel2

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


- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.params = params;
        self.title = params[SUViewModelTitleKey];
        
        /// 默认在viewDidLoad里面加载本地和服务器的数据
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
    }
    return self;
}


- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}


/// sub class can override
- (void)initialize {}


@end
