//
//  MHConstant.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  全局细线高度 .75f
 */
CGFloat const MHGlobalBottomLineHeight = .55f;


/**
 *  UIView 动画时长
 */
NSTimeInterval const MHAnimateDuration = .35f;

/**
 *  全局控制器顶部间距 10
 */
CGFloat const MHGlobalViewTopInset = 10.0f;

/**
 *  全局控制器左边间距 12
 */
CGFloat const MHGlobalViewLeftInset = 12.0f;

/**
 *  全局控制器中间间距 10
 */
CGFloat const MHGlobalViewInterInset = 10.0f;





/** 百思不得姐 -顶部标题的高度 */
CGFloat const MHTitilesViewH = 44;
/** 百思不得姐-顶部标题的Y */
CGFloat const MHTitilesViewY = 64;


/** 网易新闻-颜色 R、G、B、A*/
CGFloat const MHTopicLabelRed = .4f;
CGFloat const MHTopicLabelGreen = .6f;
CGFloat const MHTopicLabelBlue = .7f;
CGFloat const MHTopicLabelAlpha = 1.0f;

// 仿微信朋友圈评论和回复
// 段头+cell+表头
/**  话题头像宽高 */
CGFloat const MHTopicAvatarWH = 30.0f ;
/**  话题水平方向间隙 */
CGFloat const MHTopicHorizontalSpace = 10.0f;
/**  话题垂直方向间隙 */
CGFloat const MHTopicVerticalSpace = 10.0f ;
/**  话题更多按钮宽 */
CGFloat const MHTopicMoreButtonW = 24.0f ;

/**  评论水平方向间隙 */
CGFloat const MHCommentHorizontalSpace = 11.0f;
/**  评论垂直方向间隙 */
CGFloat const MHCommentVerticalSpace = 7.0f;

/** 文本行高 */
CGFloat const  MHCommentContentLineSpacing = 10.0f;

/** 评论假数据的id */
NSString * const MHAllCommentsId = @"MHAllCommentsId" ;

/** 评论用户的key */
NSString * const MHCommentUserKey = @"MHCommentUserKey";

/** 评论高度 */
CGFloat const MHCommentHeaderViewHeight = 100.0f;

/** 评论工具高度 */
CGFloat const MHCommentToolBarHeight  = 44.0f  ;

/** 最大字数 */
NSInteger const MHCommentMaxWords  = 300  ;


/** 每页数据 */
NSUInteger const MHCommentMaxCount = 30;

/** 弹出评论框View最小距离 */
CGFloat const MHTopicCommentToolBarMinHeight = 105;

/** 弹出评论框View的除了编辑框的高度 */
CGFloat const MHTopicCommentToolBarWithNoTextViewHeight = 75;






/** 视频评论成功的通知 */
NSString * const MHCommentSuccessNotification = @"MHCommentSuccessNotification";
/** 视频评论成功Key */
NSString * const MHCommentSuccessKey = @"MHCommentSuccessKey" ;

/** 视频点赞成功的通知 */
NSString * const MHThumbSuccessNotification = @"MHThumbSuccessNotification" ;


/** 视频评论回复成功的通知 */
NSString * const MHCommentReplySuccessNotification = @"MHCommentReplySuccessNotification" ;
/** 视频评论回复成功Key */
NSString * const MHCommentReplySuccessKey = @"MHCommentReplySuccessKey" ;

/** 视频评论获取成功的事件 */
NSString * const MHCommentRequestDataSuccessNotification = @"MHCommentRequestDataSuccessNotification" ;
/** 视频评论获取成功的事件 */
NSString * const MHCommentRequestDataSuccessKey = @"MHCommentRequestDataSuccessKey" ;


/** titleView高度 */
CGFloat const MHRecommendTitleViewHeight = 32.0f;
/** 选集view高度 */
CGFloat const MHRecommendAnthologyViewHeight = 44.0f;
/** 选集纯文本HeaderView高度 */
CGFloat const MHRecommendAnthologyHeaderViewHeight = 91.0f;
/** 评论高度 */
CGFloat const MHRecommendCommentHeaderViewHeight = 100.0f;

