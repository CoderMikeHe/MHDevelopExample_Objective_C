//
//  MHUITableViewStyleGroupedBugController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/3/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHUITableViewStyleGroupedBugController.h"
#import "MHOperationCell.h"

@interface MHUITableViewStyleGroupedBugController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic , weak) UITableView *tableView;
/** 所有indexPath */
@property (nonatomic , strong) NSMutableArray *dataSource;
@end

@implementation MHUITableViewStyleGroupedBugController

- (void)dealloc
{
    MHDealloc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
}
#pragma mark ------------ 公共方法


#pragma mark ------------ 私有方法
#pragma mark - Getter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - 初始化
- (void)_setup
{
    // 初始化假数据
    for (NSInteger i = 0; i < 5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:indexPath];
    }
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"UITableViewStyleGrouped";
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建tableView
    [self _setupTableView];
    
}
// 创建tableView
- (void)_setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor greenColor];
    tableView.rowHeight = 70;
    tableView.sectionHeaderHeight = 30.f;
    tableView.sectionFooterHeight = .1f;
    tableView.allowsMultipleSelection = NO;
    tableView.allowsSelectionDuringEditing = NO;
    tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    //方式一：设置标头的高度为特小值 （不能为零 为零的话苹果会取默认值就无法消除头部间距了）
//    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MHMainScreenWidth, CGFLOAT_MIN)];
    // 以下这种写法无效
//    tableView.tableHeaderView = nil;
//    tableView.tableHeaderView = [[UIView alloc] init];
//    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    /// 去除tableView上多余的分割线
    tableView.tableFooterView = [[UIView alloc] init];
    
    // 方式三：
    /// 设置tableView的contentInset
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
}


#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHOperationCell *cell = [MHOperationCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    return cell;
}


// 方式二
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return CGFLOAT_MIN;
//}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MHLog(@"-- %@" , NSStringFromCGPoint(self.tableView.contentOffset));
}




@end
