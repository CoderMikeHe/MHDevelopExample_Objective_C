//
//  MHYouKuAnthologyHeaderView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHYouKuAnthologyHeaderView,MHYouKuAnthologyItem;

@protocol MHYouKuAnthologyHeaderViewDelegate <NSObject>

@optional
/** 更多按钮被点击 */
- (void)anthologyHeaderViewForMoreButtonAction:(MHYouKuAnthologyHeaderView *)anthologyHeaderView;

/** 视频选中哪一集 */
- (void)anthologyHeaderView:(MHYouKuAnthologyHeaderView *)anthologyHeaderView mediaBaseId:(NSString *)mediaBaseId;
@end


@interface MHYouKuAnthologyHeaderView : UITableViewHeaderFooterView

+ (instancetype)anthologyHeaderView;

/** head */
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

/** 代理 */
@property (nonatomic , weak) id <MHYouKuAnthologyHeaderViewDelegate> delegate;

/** 容器 */
@property (nonatomic , strong) MHYouKuAnthologyItem *anthologyItem;

@end
