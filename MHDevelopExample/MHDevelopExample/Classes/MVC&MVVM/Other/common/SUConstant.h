//
//  SUConstant.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVC&MVVM的常亮头文件

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 全局细下滑线颜色 以及分割线颜色
#define SUGlobalBottomLineColor     [UIColor colorFromHexString:@"#D9D9D9"]



/// 全局粉红色
#define SUGlobalPinkColor [UIColor colorFromHexString:@"#FE8491"]
/// 全局浅粉红色
#define SUGlobalShadowPinkColor [UIColor colorFromHexString:@"#FFF1F2"]
/// 全局亮红色 V1.4.0 @"#FE583E"
#define SUGlobalLightRedColor [UIColor colorFromHexString:@"#FE583E"]



/// 全局灰色背景 V1.4.0 @"#EEEFF4"
#define SUGlobalGrayBackgroundColor [UIColor colorFromHexString:@"#EEEFF4"]
/// 全局浅灰色字体 V1.4.0 @"#9CA1B2"
#define SUGlobalShadowGrayTextColor [UIColor colorFromHexString:@"#9CA1B2"]




/// 全局黑色字体
#define SUGlobalBlackTextColor      [UIColor colorFromHexString:@"#3C3E44"]
/// 全局浅黑色字体 V1.4.0 @"#56585f"
#define SUGlobalShadowBlackTextColor      [UIColor colorFromHexString:@"#56585f"]





/// 左、右距离屏幕的间距 12
FOUNDATION_EXTERN CGFloat const SUGlobalViewLeftOrRightMargin;
/// 顶部、底部、中间间距 距离屏幕的间距 10
FOUNDATION_EXTERN CGFloat const SUGlobalViewInnerMargin;


/// MVC
/// 登录的手机号
FOUNDATION_EXTERN NSString *const SULoginPhoneKey0;
/// 登录的验证码
FOUNDATION_EXTERN NSString *const SULoginVerifyCodeKey0;

/// MVVM Without RAC
/// 登录的手机号
FOUNDATION_EXTERN NSString *const SULoginPhoneKey1;
/// 登录的验证码
FOUNDATION_EXTERN NSString *const SULoginVerifyCodeKey1;


/// 搜索tips
FOUNDATION_EXTERN NSString *const SUSearchTipsText;


/// 首页banner视图的高度
#define SUGoodsBannerViewHeight  ceil((MHMainScreenWidth * 238.0f / 375.0f))


////////////////// MVVM ViewModel Params中的key //////////////////
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

