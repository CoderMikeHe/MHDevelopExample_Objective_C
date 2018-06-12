//
//  CMHExample13ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample13ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"
#import "CMHOperationToolBar.h"
@interface CMHExample13ViewController ()
/// bottomToolbar
@property (nonatomic , readwrite , weak) CMHOperationToolBar *bottomToolbar;

/// 全选/取消
@property (nonatomic , readwrite , weak) MHButton *checkAllBtn;

/// 删除
@property (nonatomic , readwrite , weak) MHButton *deleteBtn;

/// closeItem
@property (nonatomic , readwrite , strong) UIBarButtonItem *closeItem;
/// editItem
@property (nonatomic , readwrite , strong) UIBarButtonItem *editItem;
/// 原始的item
@property (nonatomic , readwrite , strong) UIBarButtonItem *originLeftItem;

/// 是否是编辑状态
@property (nonatomic , readwrite , assign , getter = isEditState) BOOL editState;
@end

@implementation CMHExample13ViewController


/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 支持上拉加载，下拉刷新
        self.shouldPullDownToRefresh = YES;
        self.shouldPullUpToLoadMore = YES;
        
        /// 是否一进来就开始加载数据 默认YES
        self.shouldBeginRefreshing = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
}

#pragma mark - Override
- (void)configure{
    [super configure];
    
}

- (void)tableViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    self.page = 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// 清掉数据源
        [self.dataSource removeAllObjects];
        
        /// 模拟数据
        for (NSInteger i = 0; i < self.perPage; i++) {
            NSString *title = [NSString stringWithFormat:@"这是第%ld条优秀数据",(long)i];
            CMHExampleTableTest * et = [[CMHExampleTableTest alloc] init];
            et.idNum = i;
            et.title = title;
            [self.dataSource addObject:et];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self tableViewDidFinishTriggerHeader:YES reload:YES];
        
    });
}

- (void)tableViewDidTriggerFooterRefresh{
    /// 下拉加载事件 子类重写
    self.page = self.page + 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        /// 模拟数据
        for (NSInteger i = 0; i < self.perPage; i++) {
            NSString *title = [NSString stringWithFormat:@"这是第%ld条优秀数据",(long)(i + (self.page - 1) * self.perPage)];
            CMHExampleTableTest * et = [[CMHExampleTableTest alloc] init];
            et.idNum = i + (self.page - 1) * self.perPage;
            et.title = title;
            [self.dataSource addObject:et];
        }
        
        /// 告诉系统你是否结束刷新 , 这个方法我们手动调用，无需重写
        [self tableViewDidFinishTriggerHeader:NO reload:YES];
        
    });
}


/// 生成一个可复用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHExampleTableTestCell cellWithTableView:tableView];
}

/// 为Cell配置数据
- (void)configureCell:(CMHExampleTableTestCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell setIndexPath:indexPath rowsInSection:self.dataSource.count];
    [cell configureModel:object];
}


#pragma mark - 事件处理Or辅助方法
/// 关闭工具条
- (void)_closeItemDidClicked:(UIBarButtonItem *)sender{
    
    self.title = @"足迹";
    
    self.navigationItem.leftBarButtonItem = self.originLeftItem;
    self.navigationItem.rightBarButtonItem = self.editItem;
    
    [self.bottomToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(CMHBottomMargin(54));
    }];
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.editState = NO;
    /// 重置上下拉刷新
    self.shouldPullUpToLoadMore = YES;
    self.shouldPullDownToRefresh = YES;
    
    /// 配置数据源
    for (CMHExampleTableTest *et in self.dataSource) {
        et.editState = NO;
        et.selected = NO;
    }
    [self reloadData];
    
    /// 重置底部
    self.bottomToolbar.checkAllItem.selected = NO;
}

/// 显示底部工具条
- (void)_editItemDidClicked:(UIBarButtonItem *)sender{
    
    self.title = @"编辑";
    
    /// 记录左侧
    self.originLeftItem = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.closeItem;
    self.navigationItem.rightBarButtonItem = nil;
    
    /// 动画
    [self.bottomToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.editState = YES;
    /// 取消掉上下拉刷新
    self.shouldPullUpToLoadMore = NO;
    self.shouldPullDownToRefresh = NO;
    
    
    /// 配置数据源
    for (CMHExampleTableTest *et in self.dataSource) {
        et.editState = YES;
    }
    [self reloadData];
    
    /// 重置底部
    self.bottomToolbar.checkAllItem.selected = NO;
    
}
/// 全选操作
- (void)_checkAllOperation{

    if (self.dataSource.count == 0){
        self.title = @"编辑";
        return;  /// 前提你得有数据
    }
    
    for (CMHExampleTableTest *et in self.dataSource) {
        et.selected = self.bottomToolbar.checkAllItem.isSelected;
    }
    [self reloadData];
    
    NSString *title = @"编辑";
    if (self.bottomToolbar.checkAllItem.isSelected) {
        title = [NSString stringWithFormat:@"已选择%ld条数据" ,self.dataSource.count];
    }
    self.title = title;
}

/// 删除操作
- (void)_deleteOperation{
    
    /// 选出所有的选中的东西
    NSMutableArray *ids = [NSMutableArray array];
    /// 记录数据
    NSMutableArray *dataSource = [NSMutableArray array];
    
    for (CMHExampleTableTest *et in self.dataSource) {
        if (et.isSelected) {
            [ids addObject:[NSString stringWithFormat:@"%ld",(long)et.idNum]];
        }else{
            [dataSource addObject:et];
        }
    }
    
    if (ids.count == 0) {
        [MBProgressHUD mh_showTips:@"敢不敢选中一条数据"];
        return;
    }
    
    NSString *idstr = [ids componentsJoinedByString:@","];
    
    /// show hud
    [MBProgressHUD mh_showProgressHUD:@"Delete..." addedToView:self.view];
    
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// hide hud
        [MBProgressHUD mh_hideHUDForView:self.view];
        
        [MBProgressHUD mh_showTips:@"Delete Success" addedToView:self.view];
        
        self.title = @"编辑";
        
        /// 先删除 后添加
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:dataSource];
        [self reloadData];
        self.title = @"编辑";
    });
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMHExampleTableTest *et = self.dataSource[indexPath.row];
    if (self.isEditState) { /// 编辑状态
        
        et.selected = !et.isSelected;
        [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        
        /// 增加用户体验 已选择2条数据
        NSString *title = @"编辑";
        NSInteger count = 0;
        BOOL isCheckAll = YES;
        for (CMHExampleTableTest *e in self.dataSource) {
            if (!e.isSelected) { /// 一旦有一个 没被选中 ，则就为全选
                isCheckAll = NO;
            }else{
                count++;
            }
        }
        self.bottomToolbar.checkAllItem.selected = isCheckAll;
        if (count>0) {
            title = [NSString stringWithFormat:@"已选择%ld条数据" ,count];
        }
        self.title = title;
        
        return;
    }
    
    
    CMHViewController *temp = [[CMHViewController alloc] initWithParams:nil];
    temp.title = [NSString stringWithFormat:@"第%ld条数据",et.idNum];
    [self.navigationController pushViewController:temp animated:YES];
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example13";
    self.tableView.rowHeight = 55;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = self.editItem;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    @weakify(self);
    /// 编辑操作按钮
    CMHOperationToolBar *bottomToolbar = [[CMHOperationToolBar alloc] initWithShowType:CMHOperationToolBarShowTypeCollect selectedOperationType:^(CMHOperationToolBarType type) {
        /// 全选 /// 删除
        @strongify(self);
        switch (type) {
            case CMHOperationToolBarTypeCheckAll:
                [self _checkAllOperation];
                break;
            case CMHOperationToolBarTypeDelete:
                [self _deleteOperation];
                break;
            default:
                break;
        }
    }];
    
    [self.view addSubview:bottomToolbar];
    self.bottomToolbar = bottomToolbar;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomToolbar.mas_top);
    }];
    
    
    [self.bottomToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(CMHBottomMargin(54));
        make.bottom.equalTo(self.view).with.offset(CMHBottomMargin(54));
    }];
}

#pragma mark - Setter & Getter
- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"off_white" target:self selector:@selector(_closeItemDidClicked:) textType:NO];
    }
    return _closeItem;
}

- (UIBarButtonItem *)editItem{
    if (_editItem == nil) {
        _editItem  = [UIBarButtonItem mh_systemItemWithTitle:@"编辑" titleColor:UIColor.whiteColor imageName:nil target:self selector:@selector(_editItemDidClicked:) textType:YES];
    }
    return _editItem ;
}

@end
