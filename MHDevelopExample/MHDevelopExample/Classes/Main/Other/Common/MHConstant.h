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
#import "YYText.h"
#import "MHImageView.h"
#import "MHDivider.h"
#import "UIBarButtonItem+MHExtension.h"
#import "UIView+MH.h"
#import "UIFont+MHExtension.h"
#import "NSString+MH.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MHWebImageTool.h"
#import "NSObject+MH.h"
#import "MHButton.h"

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

/**
 *  全局细线高度 .75f
 */
UIKIT_EXTERN CGFloat const MHGlobalBottomLineHeight;

/**
 *  UIView 动画时长
 */
UIKIT_EXTERN NSTimeInterval const MHAnimateDuration ;

/**
 *  全局默认头像
 */
#define MHGlobalUserDefaultAvatar [UIImage imageNamed:@"mh_defaultAvatar"]


// 父子控制器
/** 百思不得姐 -顶部标题的高度 */
UIKIT_EXTERN CGFloat const MHTitilesViewH;
/** 百思不得姐-顶部标题的Y */
UIKIT_EXTERN CGFloat const MHTitilesViewY;

/** 网易新闻-颜色 R、G、B、A*/
UIKIT_EXTERN CGFloat const MHTopicLabelRed;
UIKIT_EXTERN CGFloat const MHTopicLabelGreen;
UIKIT_EXTERN CGFloat const MHTopicLabelBlue;
UIKIT_EXTERN CGFloat const MHTopicLabelAlpha;



// 仿微信朋友圈评论和回复
// 段头+cell+表头
/**  话题头像宽高 */
UIKIT_EXTERN CGFloat const MHVideoTopicAvatarWH ;
/**  话题水平方向间隙 */
UIKIT_EXTERN CGFloat const MHVideoTopicHorizontalSpace;
/**  话题垂直方向间隙 */
UIKIT_EXTERN CGFloat const MHVideoTopicVerticalSpace ;
/**  话题更多按钮宽 */
UIKIT_EXTERN CGFloat const MHVideoTopicMoreButtonW ;


/**  话题内容字体大小 */
#define MHVideoTopicTextFont MHMediumFont(12.0f)
/**  话题昵称字体大小 */
#define MHVideoTopicNicknameFont MHMediumFont(10.0f)
/**  话题点赞字体大小 */
#define MHVideoTopicZanFont MHMediumFont(10.0f)
/**  话题时间字体大小 */
#define MHVideoTopicCreateTimeFont MHMediumFont(10.0f)




/**  评论水平方向间隙 */
UIKIT_EXTERN CGFloat const MHVideoCommentHorizontalSpace ;
/**  评论垂直方向间隙 */
UIKIT_EXTERN CGFloat const MHVideoCommentVerticalSpace;

/**  评论内容字体大小 */
#define MHVideoCommentTextFont MHMediumFont(12.0f)

/** 文本行高 */
UIKIT_EXTERN CGFloat const  MHVideoCommentContentLineSpacing;


/** 评论假数据 */
UIKIT_EXTERN NSString * const MHVideoAllCommentsId ;


/** 评论用户的key */
UIKIT_EXTERN NSString * const MHCommentUserKey ;
