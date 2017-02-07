//
//  MHConstant.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Colours.h"
#import "UIBarButtonItem+MHExtension.h"
#import "UIView+MH.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
/**
 * 设置颜色
 */
#define MHColorFromHexString(__hexString__) [UIColor colorFromHexString:__hexString__]

/**
 *  全局灰色色字体颜色 + placeHolder字体颜色
 */
#define MHGlobalGrayTextColor       [UIColor colorFromHexString:@"#999999"]

/**
 *  全局白色字体
 */
#define MHGlobalWhiteTextColor      [UIColor colorFromHexString:@"#ffffff"]

/**
 *  全局黑色字体
 */
#define MHGlobalBlackTextColor      [UIColor colorFromHexString:@"#323232"]
/**
 *  全局浅黑色字体
 */
#define MHGlobalShadowBlackTextColor      [UIColor colorFromHexString:@"#646464"]

/**
 *  全局灰色 背景
 */
#define MHGlobalGrayBackgroundColor [UIColor colorFromHexString:@"#f8f8f8"]

/**
 *  全局细下滑线颜色 以及分割线颜色
 */
#define MHGlobalBottomLineColor     [UIColor colorFromHexString:@"#d6d7dc"]

/**
 *  全局橙色
 */
#define MHGlobalOrangeTextColor      [UIColor colorFromHexString:@"#FF9500"]



// 父子控制器
/** 百思不得姐 -顶部标题的高度 */
UIKIT_EXTERN CGFloat const MHTitilesViewH;
/** 百思不得姐-顶部标题的Y */
UIKIT_EXTERN CGFloat const MHTitilesViewY;

/** 网易新闻-颜色 R、G、B、A*/
UIKIT_EXTERN const CGFloat MHTopicLabelRed;
UIKIT_EXTERN const CGFloat MHTopicLabelGreen;
UIKIT_EXTERN const CGFloat MHTopicLabelBlue;
UIKIT_EXTERN const CGFloat MHTopicLabelAlpha;








