//
//  MHTopicManager.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  单例模型

#import <Foundation/Foundation.h>
#import "MHTopicFrame.h"
#import "MHCommentReply.h"

@interface MHTopicManager : NSObject

MHSingletonH(Manager)

/** 视频评论字典  */
@property (nonatomic , strong) NSMutableDictionary *commentDictionary;

/** 评论回复字典 */
@property (nonatomic , strong) NSMutableDictionary *replyDictionary;

// 返回评论回复模型
- (MHCommentReply *)commentReplyWithModel:(id)model;

/** 通过一个评论模型数组 获取一个评论尺寸模型数组 */
- (NSArray *)commentFramesWithComments:(NSArray *)comments;
@end
