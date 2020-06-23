//
//  MHRootViewController.m
//  MHDevelopExample
//
//  Created by 何千元 on 2020/6/23.
//  Copyright © 2020 CoderMikeHe. All rights reserved.
//

#import "MHRootViewController.h"

@interface MHModule : NSObject

/// icon
@property (nonatomic, readwrite, copy) NSString *icon;

/// 模块名
@property (nonatomic, readwrite, copy) NSString *name;

/// 切换到哪个模块
@property (nonatomic, readwrite, assign) MHSwitchToRootType type;

@end

@implementation MHModule

@end


@interface MHRootViewController ()<UITableViewDelegate , UITableViewDataSource>

/** tableView */
@property (nonatomic, readwrite, weak) UITableView *tableView;

/// modules
@property (nonatomic, readwrite, strong) NSMutableArray *modules;
@end

@implementation MHRootViewController

- (void)dealloc{
    MHDealloc;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter
- (NSMutableArray *)modules{
    if (_modules == nil) {
        _modules = [[NSMutableArray alloc] init];
        
        MHModule *m0 = [[MHModule alloc] init];
        m0.name = @"iOS实用开发Demo";
        m0.icon = @"module";
        m0.type = MHSwitchToRootTypeModule;
        
        MHModule *m1 = [[MHModule alloc] init];
        m1.name = @"基于MVC的基类设计";
        m1.icon = @"architecture";
        m1.type = MHSwitchToRootTypeArchitecture;
        
        [_modules addObject:m0];
        [_modules addObject:m1];
    }
    return _modules;
}

#pragma mark - 初始化
- (void)_setup
{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"CoderMikeHe";
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
    // 初始化tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.rowHeight = 56;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // 布局
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}




#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.modules count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = MHRegularFont_17;
        cell.textLabel.textColor = MHColorFromHexString(@"#1a1a1a");
        cell.accessoryView = [[UIImageView alloc] initWithImage:MHImageNamed(@"uf_filter_next")];
        cell.imageView.size = CGSizeMake(24.0f, 24.0f);
    }
    MHModule *m = self.modules[indexPath.row];
    cell.imageView.image = MHImageNamed(m.icon);
    cell.textLabel.text = m.name;
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MHModule *m = self.modules[indexPath.row];
    /// 发通知
    [MHNotificationCenter postNotificationName:MHSwitchRootViewControllerNotification object:nil userInfo:@{MHSwitchRootViewControllerUserInfoKey: @(m.type)}];
}


@end
