//
//  MHSelectsController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHSelectsController.h"
#import "MHBackButton.h"
#import "MHOperationCell.h"
#import "MHOperationController.h"

static CGFloat const MHDeleteButtonHeight = 50.0f;

@interface MHSelectsController ()<UITableViewDelegate , UITableViewDataSource>

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** leftBarButtonItem */
@property (nonatomic , strong) MHButton *leftBarButtonItem;
/** rightBarButtonItem */
@property (nonatomic , strong) MHButton *rightBarButtonItem;
/** backBarButtonItem */
@property (nonatomic , strong) MHBackButton *backBarButtonItem;

/** 所有indexPath */
@property (nonatomic , strong) NSMutableArray *dataSource;
/** 远中的数据 */
@property (nonatomic , strong) NSMutableArray *selectedDatas;
/** 删除 */
@property (nonatomic , strong) UIButton *deleteBtn;

@end

@implementation MHSelectsController

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
    self.title = @"多选和删除功能";
    
    // 右侧
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItem];
    
    // 左侧
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButtonItem];
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

- (MHButton *)leftBarButtonItem
{
    if (_leftBarButtonItem == nil) {
        _leftBarButtonItem = [[MHButton alloc] init];
        [_leftBarButtonItem setTitle:@"全选" forState:UIControlStateNormal];
        [_leftBarButtonItem setTitle:@"取消全选" forState:UIControlStateSelected];
        [_leftBarButtonItem setTitleColor:MHGlobalBlackTextColor forState:UIControlStateNormal];
        [_leftBarButtonItem addTarget:self action:@selector(_leftBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftBarButtonItem.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        _leftBarButtonItem.mh_size = CGSizeMake(100, 44);
        _leftBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _leftBarButtonItem;
}

- (MHBackButton *)backBarButtonItem
{
    if (_backBarButtonItem == nil) {
        _backBarButtonItem = [[MHBackButton alloc] init];
        [_backBarButtonItem setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [_backBarButtonItem setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        _backBarButtonItem.frame = CGRectMake(0, 0, 100, 44);
        // 监听按钮点击
        [_backBarButtonItem addTarget:self action:@selector(_backBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBarButtonItem;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedDatas
{
    if (_selectedDatas == nil) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}

- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        _deleteBtn.adjustsImageWhenHighlighted = NO;
        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_nor") forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_high") forState:UIControlStateDisabled];
        [_deleteBtn addTarget:self action:@selector(_deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}


#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 创建tableView
    [self _setupTableView];
    
    // 删除按钮
    [self _setupDeleteButton];
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
    tableView.allowsMultipleSelection = YES;
    tableView.allowsSelectionDuringEditing = YES;
    tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

}

// 删除按钮
- (void)_setupDeleteButton
{
    [self.view addSubview:self.deleteBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(MHDeleteButtonHeight);
    }];
}


#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}


#pragma mark - 点击事件处理
- (void)_rightBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        
        // 取消
        [self.tableView setEditing:YES animated:NO];

        
        // 全选
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButtonItem];
        self.leftBarButtonItem.selected = NO;
        
        // show
        [self _showDeleteButton];
 
    }else{
        
        // 清空选中栏
        [self.selectedDatas removeAllObjects];
        
        // 编辑
        [self.tableView setEditing:NO animated:NO];
        
        // 返回
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButtonItem];
        
        // hide
        [self _hideDeleteButton];
    }
}


- (void)_leftBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 全选
        NSInteger count = self.dataSource.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataSource[i];
            if (![self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }else{
        // 取消全选
        NSInteger count = self.dataSource.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataSource[i];
            if ([self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas removeObject:indexPath];
                
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }

    // 设置状态
    [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
}

/** 返回按钮点击事件 */
- (void)_backBarButtonItemDidClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 删除 */
- (void)_deleteBtnDidClicked:(UIButton *)sender
{
    // 删除
    /**
     *  这里删除操作交给自己处理
     */
    [self _deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    
}

#pragma mark - 显示和隐藏 删除按钮
- (void)_showDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-1*MHDeleteButtonHeight);
    }];
    
    // 更新约束
    [self _updateConstraints];
}

- (void)_hideDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    // 更新约束
    [self _updateConstraints];
}




#pragma mark - 辅助方法
// 更新布局
- (void)_updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 弹出框点击确认
- (void)_alertControllerDidConfirmComplete:(void(^)())complete
{
    // 弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"即将删除所选视频\n该操作不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    
    // action
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        !complete ? :complete();
        
    }];
    
    
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataSource.count;
    self.leftBarButtonItem.selected = (currentCount==allCount);
    NSString *title = (currentCount>0)?[NSString stringWithFormat:@"删除(%zd)",currentCount]:@"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount>0;
}

// delete收藏视频
- (void)_deleteSelectIndexPaths:(NSArray *)indexPaths
{
    // 删除数据源
    [self.dataSource removeObjectsInArray:self.selectedDatas];
    [self.selectedDatas removeAllObjects];
    
    // 删除选中项
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    // 验证数据源
    [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
    
    // 验证
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
    
    // 是否修改系统的选中按钮的样式 默认是NO 即系统样式
    cell.modifySelectionStyle = YES;
    
 
    return cell;
}


// 选中
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.isEditing) {
        
        // 获取cell编辑状态选中情况下的所有子控件
//        NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }

    
    
    MHOperationController *operation = [[MHOperationController alloc] init];
    NSIndexPath *indexP = self.dataSource[indexPath.row];
    operation.title = [NSString stringWithFormat:@"仙剑奇侠传 第%zd集",indexP.row];
    [self.navigationController pushViewController:operation animated:YES];
    
}

// 取消选中
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 提交编辑操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


@end
