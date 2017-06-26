//
//  SUViewModel2.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的所有自定义ViewModel的父类

#import <Foundation/Foundation.h>


//// PS： 这里应该有以下外部变量的,但是为了兼容 MVVM Without RAC的设计模式，笔者把其放置在 SUConstant.h/.m中，大家可以去看看。
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


@interface SUViewModel2 : NSObject
/// Initialization method. This is the preferred way to create a new view model.
///
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithParams:(NSDictionary *)params;

/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `kBaseViewModelParamsKey`
@property (nonatomic, readonly, copy) NSDictionary *params;

/// navItem.title
@property (nonatomic, readwrite, copy) NSString *title;


/// The callback block.
@property (nonatomic, readwrite, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, readonly, strong) RACSubject *errors;

/** should fetch local data when viewModel init . default is YES */
@property (nonatomic, readwrite, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
/** should request data when viewController videwDidLoad . default is YES*/
@property (nonatomic, readwrite, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithParams:` method. But
/// the premise is that you need to inherit `BaseViewModel`.
- (void)initialize;



@end
