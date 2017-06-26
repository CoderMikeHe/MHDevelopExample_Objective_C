//
//  SUConstant.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.


#import "SUConstant.h"

//// 左、右距离屏幕的间距 12
CGFloat const SUGlobalViewLeftOrRightMargin = 12;
/// 顶部、底部、中间间距 距离屏幕的间距 10
CGFloat const SUGlobalViewInnerMargin = 10;

//// MVC
//// 登录的手机号
NSString *const SULoginPhoneKey0 = @"SULoginPhoneKey0";
//// 登录的验证码
NSString *const SULoginVerifyCodeKey0 = @"SULoginVerifyCodeKey0";

/// MVVM Without RAC
//// 登录的手机号
NSString *const SULoginPhoneKey1 = @"SULoginPhoneKey1";
//// 登录的验证码
NSString *const SULoginVerifyCodeKey1 = @"SULoginVerifyCodeKey1";


/// MVVM With RAC
//// 登录的手机号
NSString *const SULoginPhoneKey2 = @"SULoginPhoneKey2";
//// 登录的验证码
NSString *const SULoginVerifyCodeKey2 = @"SULoginVerifyCodeKey2";


/// 项目中关于一些简单的业务逻辑验证放在ViewModel的命令中统一处理 NSError
/// eg：假设验证出来不是正确的手机号：
/// [RACSignal error:[NSError errorWithDomain:SUCommandErrorDomain code:SUCommandErrorCode userInfo:@{SUCommandErrorUserInfoKey:@"请输入正确的手机号码"}]];
NSString * const SUCommandErrorDomain = @"SUCommandErrorDomain";
NSString * const SUCommandErrorUserInfoKey = @"SUCommandErrorUserInfoKey";
CGFloat    const SUCommandErrorCode = 7438;

/// 搜索tips
NSString *const SUSearchTipsText = @"输入你要找的宝贝";



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















