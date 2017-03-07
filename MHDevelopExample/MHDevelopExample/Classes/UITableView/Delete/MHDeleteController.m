//
//  MHDeleteController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDeleteController.h"
#import "MHOperationCell.h"
#import "MHOperationController.h"

@interface MHDeleteController ()
<UITableViewDelegate , UITableViewDataSource>

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** rightBarButtonItem */
@property (nonatomic , strong) MHButton *rightBarButtonItem;

/** 所有indexPath */
@property (nonatomic , strong) NSMutableArray *dataSource;


@end

@implementation MHDeleteController

- (void)dealloc
{
    MHDealloc;
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
    
    // 监听通知中心
    [self _addNotificationCenter];
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - 初始化
- (void)_setup
{
    self.fd_interactivePopDisabled = YES;
    
    // 初始化假数据
    for (NSInteger i = 0; i < 100; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:indexPath];
    }
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"左滑删除功能";
    
    // 右侧
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItem];
 
}



#pragma mark - Getter
- (MHButton *)rightBarButtonItem
{
    if (_rightBarButtonItem == nil) {
        _rightBarButtonItem = [[MHButton alloc] init];
        [_rightBarButtonItem setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBarButtonItem setTitle:@"取消" forState:UIControlStateSelected];
        [_rightBarButtonItem setTitleColor:MHGlobalBlackTextColor forState:UIControlStateNormal];
        [_rightBarButtonItem setTitleColor:MHGlobalGrayTextColor forState:UIControlStateDisabled];
        [_rightBarButtonItem addTarget:self action:@selector(_rightBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _rightBarButtonItem.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        _rightBarButtonItem.mh_size = CGSizeMake(100, 44);
        _rightBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightBarButtonItem;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
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
    
}


#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}


#pragma mark - 点击事件处理
// 编辑按钮被点击
- (void)_rightBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        
        // 取消
        [self.tableView setEditing:YES animated:NO];

    }else{
        // 编辑
        [self.tableView setEditing:NO animated:NO];

    }
}





#pragma mark - 辅助方法
// delete收藏视频
- (void)_deleteSelectIndexPath:(NSIndexPath *)indexPath
{
    // 删除数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
  
    // 删除选中项
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    // 验证数据源
    // 没有
    if (self.dataSource.count == 0)
    {
        //没有收藏数据
        
        if(self.rightBarButtonItem.selected)
        {
            // 编辑状态 -- 取消编辑状态
            [self _rightBarButtonItemDidClicked:self.rightBarButtonItem];
        }
        
        self.rightBarButtonItem.enabled = NO;
        
    }
    
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
    cell.indexPath = self.dataSource[indexPath.row];
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) return;
    
    MHOperationController *operation = [[MHOperationController alloc] init];
    NSIndexPath *indexP = self.dataSource[indexPath.row];
    operation.title = [NSString stringWithFormat:@"仙剑奇侠传 第%zd集",indexP.row];
    [self.navigationController pushViewController:operation animated:YES];
    
}






-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 删除数据
        [self _deleteSelectIndexPath:indexPath];
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end
