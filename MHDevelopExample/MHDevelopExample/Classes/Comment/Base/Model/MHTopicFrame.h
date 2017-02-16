//
//  MHTopicFrame.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHTopic.h"
#import "MHCommentReply.h"
#import "MHCommentFrame.h"

@interface MHTopicFrame : NSObject

/** 头像frame */
@property (nonatomic , assign , readonly) CGRect avatarFrame;

/** 昵称frame */
@property (nonatomic , assign , readonly) CGRect nicknameFrame;
/** 点赞frame */
@property (nonatomic , assign , readonly) CGRect thumbFrame;

/** 更多frame */
@property (nonatomic , assign , readonly) CGRect moreFrame;

/** 时间frame */
@property (nonatomic , assign , readonly) CGRect createTimeFrame;

/** 话题内容frame */
@property (nonatomic , assign , readonly) CGRect textFrame;

/** height 这里只是 整个话题占据的高度 */
@property (nonatomic , assign , readonly) CGFloat height;


/** 评论尺寸模型 由于后期需要用到，所以不涉及为只读 */
@property (nonatomic , strong ) NSMutableArray *commentFrames;


/** tableViewFrame cell嵌套tableView用到 本人有点懒 ，公用了一套模型 */
@property (nonatomic , assign , readonly) CGRect tableViewFrame;


/** 话题模型 */
@property (nonatomic , strong) MHTopic *topic;




@end
