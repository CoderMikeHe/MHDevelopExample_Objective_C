//
//  SUTableViewController.h
//  SenbaUsed
//
//  Created by senba on 2017/4/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  BaseTableViewController ， next develop ， please base on it

#import "SUViewController.h"
#import "UIScrollView+MHRefresh.h"

@interface SUTableViewController : SUViewController <UITableViewDelegate , UITableViewDataSource>

/// The table view for tableView controller.
@property (nonatomic, readonly, strong) UISearchBar *searchBar;

@property (nonatomic, readonly, weak) UITableView *tableView;

@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;


/// reload tableView data , sub class can override
- (void)reloadData;

/// duqueueReusavleCell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

/// configure cell data
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;



@end
