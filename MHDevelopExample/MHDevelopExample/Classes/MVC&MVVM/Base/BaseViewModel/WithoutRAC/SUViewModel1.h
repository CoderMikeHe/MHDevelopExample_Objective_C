//
//  SUViewModel1.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的所有自定义ViewModel的父类

#import <Foundation/Foundation.h>

//// PS： 这里应该有以下外部变量的,但是为了兼容 MVVM With RAC的设计模式，笔者把其放置在 SUConstant.h/.m中，大家可以去看看。
/**
/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
 
/// 传递唯一ID的key：例如：商品id 用户id...
FOUNDATION_EXTERN NSString *const SUViewModelIDKey;
/// 传递导航栏title的key：例如 导航栏的title...
FOUNDATION_EXTERN NSString *const SUViewModelTitleKey;
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
FOUNDATION_EXTERN NSString *const SUViewModelUtilKey;
/// 传递webView Request的key：例如 webView request...
FOUNDATION_EXTERN NSString *const SUViewModelRequestKey;
 **/

@interface SUViewModel1 : NSObject
/// Initialization method. This is the preferred way to create a new view model.
///
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithParams:(NSDictionary *)params;

/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `kBaseViewModelParamsKey`
@property (nonatomic, copy, readonly) NSDictionary *params;
/// 导航栏title
@property (nonatomic, copy) NSString *title;

/// Request data from remote server ，sub class can override it
- (void)loadData:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure;

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;

@end
