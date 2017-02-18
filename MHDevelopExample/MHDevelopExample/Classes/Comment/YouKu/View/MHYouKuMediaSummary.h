//
//  MHYouKuMediaSummary.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  视频简介

#import <UIKit/UIKit.h>

@class MHYouKuMedia;

@interface MHYouKuMediaSummary : UIView

/** 详情按钮回调 **/
@property (nonatomic,copy) void(^detailCallBack)(MHYouKuMediaSummary *summary);

/** 视频 */
@property (nonatomic , strong) MHYouKuMedia *media;


+ (instancetype)summary;
@end
