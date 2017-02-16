//
//  MHTopic.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  话题模型（类似于一条说说、微博）

#import <Foundation/Foundation.h>
#import "MHComment.h"
#import "MHUser.h"

@interface MHTopic : NSObject
/** 视频的id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 话题id */
@property (nonatomic , copy) NSString * topicId;

/** 点赞数 */
@property (nonatomic , assign) long long thumbNums;

/** 点赞数string //辅助属性// */
@property (nonatomic , copy , readonly) NSString * thumbNumsString;

/** 是否点赞  0 没有点赞 1 是点赞*/
@property (nonatomic , assign , getter = isThumb) BOOL thumb;

/** 创建时间 */
@property (nonatomic , copy) NSString *creatTime;

/** 话题内容 */
@property (nonatomic, copy) NSString *text;

/** 所有评论 MHComment */
@property (nonatomic , strong) NSMutableArray *comments;

/** 用户模型 */
@property (nonatomic , strong) MHUser *user;

/** 评论总数 */
@property (nonatomic , assign) NSInteger commentsCount;

/** 富文本 */
- (NSAttributedString *)attributedText;

@end
