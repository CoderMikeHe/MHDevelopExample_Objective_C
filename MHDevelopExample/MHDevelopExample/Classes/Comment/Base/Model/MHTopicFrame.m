//
//  MHTopicFrame.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicFrame.h"

@interface MHTopicFrame ()
/** 头像frame */
@property (nonatomic , assign) CGRect avatarFrame;

/** 昵称frame */
@property (nonatomic , assign) CGRect nicknameFrame;

/** 点赞frame */
@property (nonatomic , assign) CGRect thumbFrame;

/** 更多frame */
@property (nonatomic , assign) CGRect moreFrame;

/** 时间frame */
@property (nonatomic , assign) CGRect createTimeFrame;

/** 话题内容frame */
@property (nonatomic , assign) CGRect textFrame;

/** height*/
@property (nonatomic , assign) CGFloat height;

/** tableViewFrame cell嵌套tableView用到 本人有点懒 ，公用了一套模型 */
@property (nonatomic , assign ) CGRect tableViewFrame;

@end


@implementation MHTopicFrame

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        _commentFrames = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark - Setter
- (void)setTopic:(MHTopic *)topic
{
    _topic = topic;
    
    // 整个宽度
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 头像
    CGFloat avatarX = MHTopicHorizontalSpace;
    CGFloat avatarY = MHTopicVerticalSpace;
    CGFloat avatarW = MHTopicAvatarWH;
    CGFloat avatarH = MHTopicAvatarWH;
    self.avatarFrame = (CGRect){{avatarX , avatarY},{avatarW , avatarH}};
    
    // 布局更多
    CGFloat moreW = MHTopicMoreButtonW;
    CGFloat moreX = width - moreW;
    CGFloat moreY = avatarY;
    CGFloat moreH = avatarH * .5f;
    self.moreFrame = CGRectMake(moreX, moreY, moreW, moreH);
    
    // 布局点赞按钮
    CGFloat thumbW = topic.thumbNumsString?([topic.thumbNumsString mh_sizeWithFont:MHTopicThumbFont].width + 30):44;
    CGFloat thumbX = CGRectGetMinX(self.moreFrame) - thumbW;
    CGFloat thumbY = avatarY;
    CGFloat thumbH = moreH;
    self.thumbFrame = CGRectMake(thumbX, thumbY, thumbW, thumbH);
    
    // 昵称
    CGFloat nicknameX = CGRectGetMaxX(self.avatarFrame)+MHTopicHorizontalSpace;
    CGFloat nicknameY = avatarY;
    CGFloat nicknameW = CGRectGetMinX(self.thumbFrame) - nicknameX;
    CGFloat nicknameH = moreH;
    self.nicknameFrame = CGRectMake(nicknameX, nicknameY, nicknameW, nicknameH);
    
    // 时间
    CGFloat createX = nicknameX;
    CGFloat createY = CGRectGetMaxY(self.nicknameFrame);
    CGFloat createW = width - createX;
    CGFloat createH = moreH;
    self.createTimeFrame = CGRectMake(createX, createY, createW, createH);
    
    // 内容
    CGFloat textX = nicknameX;
    CGSize textLimitSize = CGSizeMake(width - textX - MHTopicHorizontalSpace, MAXFLOAT);
    CGFloat textY = CGRectGetMaxY(self.nicknameFrame)+CGRectGetHeight(self.nicknameFrame);
    CGFloat textH = [YYTextLayout layoutWithContainerSize:textLimitSize text:topic.attributedText].textBoundingSize.height+MHTopicVerticalSpace+MHTopicVerticalSpace;
    
    self.textFrame = (CGRect){{textX , textY} , {textLimitSize.width, textH}};
    
    
    
    CGFloat tableViewX = textX;
    CGFloat tableViewY = CGRectGetMaxY(self.textFrame);
    CGFloat tableViewW = textLimitSize.width;
    CGFloat tableViewH = 0;
    // 评论数据
    if (topic.comments>0)
    {
        for (MHComment *comment in topic.comments)
        {
            MHCommentFrame *commentFrame = [[MHCommentFrame alloc] init];
            commentFrame.maxW = textLimitSize.width;
            commentFrame.comment = comment;
            [self.commentFrames addObject:commentFrame];
            
            tableViewH += commentFrame.cellHeight;
        }
    }
    
    self.tableViewFrame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    // 自身高度
    self.height = CGRectGetMaxY(self.textFrame);

}


@end
