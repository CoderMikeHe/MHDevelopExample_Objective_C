//
//  MHTopicManager.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicManager.h"

@implementation MHTopicManager

MHSingletonM(Manager)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 初始化
        _commentDictionary = [NSMutableDictionary dictionary];
        // 初始化
        _replyDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

// 返回评论回复模型
- (MHCommentReply *)commentReplyWithModel:(id)model
{
    // 回复模型
    MHCommentReply *commmentReply = [[MHCommentReply alloc] init];
    
    if ([model isKindOfClass:[MHTopic class]]){
        // 话题
        MHTopic *topic = (MHTopic *)model;
        commmentReply.mediabase_id = topic.mediabase_id;
        commmentReply.commentReplyId = topic.topicId;
        commmentReply.text = topic.text;
        commmentReply.reply = NO;
        MHUser *user = [[MHUser alloc] init];
        user.nickname = topic.user.nickname;
        user.avatarUrl = topic.user.avatarUrl;
        user.userId = topic.user.userId;
        commmentReply.user = user;
        
        return commmentReply;
        
    }else if ([model isKindOfClass:[MHComment class]]){
        // 评论
        MHComment *comment = (MHComment *)model;
        commmentReply.text = comment.text;
        commmentReply.mediabase_id = comment.mediabase_id;
        commmentReply.commentReplyId = comment.commentId;
        commmentReply.reply = YES;
        MHUser *user = [[MHUser alloc] init];
        user.nickname = comment.fromUser.nickname;
        user.avatarUrl = comment.fromUser.avatarUrl;
        user.userId = comment.fromUser.userId;
        commmentReply.user = user;
        return commmentReply;
    }
    return nil;
}

/** 通过一个评论模型数组 获取一个评论尺寸模型数组 */
- (NSArray *)commentFramesWithComments:(NSArray *)comments
{
    NSMutableArray *frames = [NSMutableArray array];
    
    for (MHComment *comment in comments) {
        MHCommentFrame *frame = [[MHCommentFrame alloc] init];
        frame.maxW = (MHMainScreenWidth - MHTopicHorizontalSpace *3 - MHTopicAvatarWH);
        // 传递微博模型数据，计算所有子控件的frame
        frame.comment = comment;
        [frames addObject:frame];
    }
    return frames;
}


@end
