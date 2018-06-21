//
//  CMHExample14ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample14ViewController.h"
#import "CMHExampleTableTest.h"
#import "CMHExampleTableTestCell.h"
@interface CMHExample14ViewController ()
/// headerView
@property (nonatomic , readwrite , weak) UIImageView *headerView;
@end

@implementation CMHExample14ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 支持上拉加载，下拉刷新
        self.shouldPullDownToRefresh = YES;
        self.shouldPullUpToLoadMore = YES;
        
        /// 是否一进来就开始加载数据 默认YES ，如果为 NO 则不会自动下拉刷新 需要开发者在子类的ViewDidLoad中手动调用 tableViewDidTriggerHeaderRefresh 方法
        /// 不自动加载
        self.shouldBeginRefreshing = NO;
        
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
    
    /// 如果 self.shouldBeginRefreshing = NO; 你需要手动调用 tableViewDidTriggerHeaderRefresh
    /// [self tableViewDidTriggerHeaderRefresh];
}

/// 请求数据
- (void)requestRemoteData{
    
    /// 常用场景：首先去服务器获取 ID , 然后根据ID去获取列表的数据
    
    [MBProgressHUD mh_showProgressHUD:@"Loadind..." addedToView:self.view];
    
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.headerView yy_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528468978072&di=e503aaa44a96181286743186d6040522&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-01-05%2F5a4f5b0464423.jpg"] placeholder:MHImageNamed(@"placeholder_image") options:CMHWebImageOptionAutomatic completion:NULL];
        
        /// 假设你获取到了ID 你再去获取列表数据
        [self tableViewDidTriggerHeaderRefresh];
        
    });

}


- (void)tableViewDidTriggerHeaderRefresh{
    /// 下拉刷新事件 子类重写
    self.page = 1;
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /// hid HUD
        [MBProgressHUD mh_hideHUDForView:self.view];
        
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
        
        /// hid HUD
        [MBProgressHUD mh_hideHUDForView:self.view];
        
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMHExampleTableTest *et = self.dataSource[indexPath.row];
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
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    /// https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528468978072&di=e503aaa44a96181286743186d6040522&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-01-05%2F5a4f5b0464423.jpg
    /// 1920 x 1200
    /// headerView
    UIImageView *headerView = [[UIImageView alloc] init];
    self.headerView = headerView;
    headerView.mh_height = MH_SCREEN_WIDTH * 1200 / 1920.0f;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter


@end
