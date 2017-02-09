//
//  MHTopicCell.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTopicFrame,MHTopicCell,MHUser;

@protocol MHTopicCellDelegate <NSObject>

@optional
/** 点击头像或昵称的事件回调 */
- (void)topicCellDidClickedUser:(MHTopicCell *)topicCell;

/** 点击头像或昵称的事件回调 */
- (void)topicCellDidClickedTopicContent:(MHTopicCell *)topicCell;

/** 用户点击更多按钮 */
- (void)topicCellForClickedMoreAction:(MHTopicCell *)topicCell;

/** 用户点击点赞按钮 */
- (void)topicCellForClickedThumbAction:(MHTopicCell *)topicCell;

/** 点击评论cell的昵称 */
- (void) topicCell:(MHTopicCell *)topicCell didClickedUser:(MHUser *)user;
/** 点击某一行的cell */
- (void) topicCell:(MHTopicCell *)topicCell  didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface MHTopicCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 话题模型数据源 */
@property (nonatomic , strong) MHTopicFrame *topicFrame;

/** 代理 */
@property (nonatomic , weak) id <MHTopicCellDelegate> delegate;

@end
