//
//  SUTableViewController2.h
//  SenbaUsed
//
//  Created by senba on 2017/4/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  BaseTableViewController ， next develop ， please base on it
//  MVVM with RAC 开发模式的所有自定义的还有表格视图（UITableView）控制器的父类

#import "SUViewController2.h"
#import "UIScrollView+MHRefresh.h"
#import "SUTableViewModel2.h"

@interface SUTableViewController2 : SUViewController2 <UITableViewDelegate , UITableViewDataSource>

/// The table view for tableView controller.
/// tableView
@property (nonatomic, readonly, weak) UITableView *tableView;
/// 内容缩进
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// reload tableView data , sub class can override
- (void)reloadData;

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/// 下拉刷新事件
- (void)tableViewDidTriggerHeaderRefresh;
/// 上拉加载事件
- (void)tableViewDidTriggerFooterRefresh;

/**
 哪个刷新事件完成
 @param isHeader 是否是下拉刷新结束
 @param reload 是否需要刷新数据
 */
- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;
@end
