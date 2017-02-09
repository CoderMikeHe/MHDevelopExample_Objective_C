//
//  MHTopicHeaderView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTopicFrame,MHTopicHeaderView,MHUser,MHTopic;

@protocol MHTopicHeaderViewDelegate <NSObject>

@optional

/** 点击头像或昵称的事件回调 */
- (void)topicHeaderViewDidClickedUser:(MHTopicHeaderView *)topicHeaderView;

/** 点击头像或昵称的事件回调 */
- (void)topicHeaderViewDidClickedTopicContent:(MHTopicHeaderView *)topicHeaderView;

/** 用户点击更多按钮 */
- (void)topicHeaderViewForClickedMoreAction:(MHTopicHeaderView *)topicHeaderView;

/** 用户点击点赞按钮 */
- (void)topicHeaderViewForClickedThumbAction:(MHTopicHeaderView *)topicHeaderView;



@end



@interface MHTopicHeaderView : UITableViewHeaderFooterView

+ (instancetype)topicHeaderView;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/** 话题模型数据源 */
@property (nonatomic , strong) MHTopicFrame *topicFrame;

/** 代理 */
@property (nonatomic , weak) id <MHTopicHeaderViewDelegate> delegate;

@end
