//
//  MHExampleController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHExampleController.h"
#import "MHExample.h"
#import "MHBuDeJieController.h"
#import "MHNetEaseNewsController.h"



@interface MHExampleController () <UITableViewDelegate , UITableViewDataSource>

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** examples */
@property (nonatomic , strong) NSMutableArray *examples;


@end

@implementation MHExampleController

- (void)dealloc
{
    //
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

#pragma mark - Getter
- (NSMutableArray *)examples
{
    if (_examples == nil) {
        
        _examples = [[NSMutableArray alloc] init];
        
        /**
         一、父子控制器
            1.1 仿百思不得姐
            1.2 仿网易新闻
         */
        MHExample *paternityExample = [[MHExample alloc] init];
        paternityExample.header = @"一、父子控制器";
        paternityExample.titles = @[@"1.1 仿百思不得姐 - MHBuDeJieController",@"1.2 仿网易新闻 - MHNetEaseNewsController"];
        paternityExample.classes = @[@"MHBuDeJieController",@"MHNetEaseNewsController"];
        [_examples addObject:paternityExample];
    }
    return _examples;
}

#pragma mark - 初始化
- (void)_setup
{
    
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
    tableView.rowHeight = 50;
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




#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.examples.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.examples[section] titles] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MHExample *example = self.examples[indexPath.section];
    cell.textLabel.text = example.titles[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MHExample *example = self.examples[section];
    return example.header;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MHExample *example = self.examples[indexPath.section];
    
    NSString* vcClassString = example.classes[indexPath.row];
    MHBuDeJieController *vc = [[NSClassFromString(vcClassString) alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
