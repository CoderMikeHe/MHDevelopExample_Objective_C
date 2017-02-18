//
//  MHYouKuTopicController.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  话题控制器

#import "MHViewController.h"


@class MHYouKuTopicController,MHYouKuCommentItem;

@protocol MHYouKuTopicControllerDelegate <NSObject>

@optional

// 关闭按钮点击事件
- (void)topicControllerForCloseAction:(MHYouKuTopicController *)topicController;

@end


@interface MHYouKuTopicController : MHViewController

/** 代理 */
@property (nonatomic , weak) id <MHYouKuTopicControllerDelegate> delegate;

/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;
/** 刷新评论数 */
- (void) refreshCommentsWithCommentItem:(MHYouKuCommentItem *)commentItem;

@end
