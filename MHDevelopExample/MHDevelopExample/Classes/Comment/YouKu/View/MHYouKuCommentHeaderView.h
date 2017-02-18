//
//  MHYouKuCommentHeaderView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHYouKuCommentHeaderView,MHYouKuCommentItem;

@protocol MHYouKuCommentHeaderViewDelegate <NSObject>

@optional
/** 评论按钮点击 */
- (void)commentHeaderViewForCommentBtnAction:(MHYouKuCommentHeaderView *)commentHeaderView;


@end


@interface MHYouKuCommentHeaderView : UITableViewHeaderFooterView

+ (instancetype)commentHeaderView;

/** head */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/** 代理 */
@property (nonatomic , weak) id <MHYouKuCommentHeaderViewDelegate> delegate;

/** 评论容器 */
@property (nonatomic , strong) MHYouKuCommentItem *commentItem;
@end
