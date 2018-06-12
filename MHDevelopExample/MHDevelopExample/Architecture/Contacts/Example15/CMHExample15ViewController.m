//
//  CMHExample15ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/9.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample15ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"
@interface CMHExample15ViewController ()

@end

@implementation CMHExample15ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 多组数据，跟组头组尾没关系
        self.shouldMultiSections = YES;
        
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

#pragma mark - 事件处理Or辅助方法

#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 0组
    CMHExampleTableTest *et0_0 = [[CMHExampleTableTest alloc] init];
    et0_0.title = @"CoderMikeHe";
    et0_0.idNum = 0;
    
    
    /// 1组
    CMHExampleTableTest *et1_0 = [[CMHExampleTableTest alloc] init];
    et1_0.title = @"钱包";
    et1_0.idNum = 1;
    
    /// 2组
    CMHExampleTableTest *et2_0 = [[CMHExampleTableTest alloc] init];
    et2_0.title = @"收藏";
    et2_0.idNum = 2;
    
    CMHExampleTableTest *et2_1 = [[CMHExampleTableTest alloc] init];
    et2_1.title = @"相册";
    et2_1.idNum = 3;
    
    
    CMHExampleTableTest *et2_2 = [[CMHExampleTableTest alloc] init];
    et2_2.title = @"卡包";
    et2_2.idNum = 4;
    
    CMHExampleTableTest *et2_3 = [[CMHExampleTableTest alloc] init];
    et2_3.title = @"表情";
    et2_3.idNum = 5;
    
    /// 3组
    CMHExampleTableTest *et3_0 = [[CMHExampleTableTest alloc] init];
    et3_0.title = @"设置";
    et3_0.idNum = 6;
    
    
    // shouldMultiSections = YES; 多组结构
    [self.dataSource addObject:@[et0_0]];
    [self.dataSource addObject:@[et1_0]];
    [self.dataSource addObject:@[et2_0 , et2_1 , et2_2 , et2_3]];
    [self.dataSource addObject:@[et3_0]];
    
    /// 刷新数据
    [self reloadData];
}

- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT + 16, 0, 0, 0);
}


/// 生成一个可复用的cell
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [CMHExampleTableTestCell cellWithTableView:tableView];
}

/// 为Cell配置数据
- (void)configureCell:(CMHExampleTableTestCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    NSArray *ets = self.dataSource[indexPath.section];
    [cell setIndexPath:indexPath rowsInSection:ets.count];
    [cell configureModel:object];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 21;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *ID = @"CMHExample15FooterView";
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (footerView == nil) {
        // 缓存池中没有, 自己创建
        footerView = [[UIView alloc] init];
        footerView.backgroundColor = self.view.backgroundColor;
    }
    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *ets = self.dataSource[indexPath.section];
    CMHExampleTableTest *et = ets[indexPath.row];
    
    CMHViewController *temp = [[CMHViewController alloc] initWithParams:nil];
    temp.title = et.title;
    [self.navigationController pushViewController:temp animated:YES];
}

#pragma mark - 初始化
- (void)_setup{
    self.tableView.rowHeight = MH_APPLICATION_TOOL_BAR_HEIGHT_44;
    self.title = @"我";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
