//
//  SUViewModel1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的所有自定义ViewModel的父类

#import "SUViewModel1.h"

//// PS 这里应该有以下外部变量的,但是为了兼容 MVVM With RAC的设计模式，笔者把其放置在 SUConstant.h/.m中，大家可以去看看。
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


@interface SUViewModel1 ()
/// 传递的参数
@property (nonatomic, copy, readwrite) NSDictionary *params;
@end

@implementation SUViewModel1

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.params = params;
        self.title = params[SUViewModelTitleKey];
    }
    return self;
}

/// request remote data
- (void)loadData:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure {
    // 子类重载
}

@end
