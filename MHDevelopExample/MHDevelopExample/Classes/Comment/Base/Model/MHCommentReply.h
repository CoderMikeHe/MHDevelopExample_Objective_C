//
//  MHCommentReply.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  回复模型

#import <Foundation/Foundation.h>
#import "MHUser.h"

@interface MHCommentReply : NSObject

/** 视频的id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 回复哪个用户的模型 */
@property (nonatomic , strong) MHUser *user;

/** 要回复的id */
@property (nonatomic , copy) NSString *commentReplyId;

/** 话题内容 */
@property (nonatomic, copy) NSString *text;

/** 是否是回复 */
@property (nonatomic, assign , getter = isReply) BOOL reply;

@end
