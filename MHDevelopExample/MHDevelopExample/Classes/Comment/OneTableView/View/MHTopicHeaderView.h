//
//  MHTopicHeaderView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTopicFrame;

@interface MHTopicHeaderView : UITableViewHeaderFooterView

+ (instancetype)topicHeaderView;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/** 话题模型数据源 */
@property (nonatomic , strong) MHTopicFrame *topicFrame;

@end
