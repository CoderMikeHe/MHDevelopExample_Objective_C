//
//  MHTopicCommentCell.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHCommentFrame,MHTopicCommentCell,MHUser;

@protocol MHTopicCommentCellDelegate <NSObject>

@optional
/** 点击评论cell的昵称 */
- (void) topicCommentCell:(MHTopicCommentCell *)topicCommentCell didClickedUser:(MHUser *)user;

@end

@interface MHTopicCommentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 评论Frame */
@property (nonatomic , strong) MHCommentFrame *commentFrame;

/** 代理 */
@property (nonatomic , weak) id <MHTopicCommentCellDelegate> delegate;
@end
