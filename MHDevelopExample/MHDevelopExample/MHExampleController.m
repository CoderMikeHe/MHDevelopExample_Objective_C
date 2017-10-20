//
//  MHExampleController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//
#import "MHExampleController.h"
#import "MHExample.h"
// 父子控制器
#import "MHBuDeJieController.h"
#import "MHNetEaseNewsController.h"
#import "MHDisplayController.h"

// 微信朋友圈评论回复
#import "MHTopicOneController.h"
#import "MHTopicTwoController.h"
#import "MHYouKuController.h"


// UITableView常见的使用场景
#import "MHSelectsController.h"
#import "MHDeleteController.h"
#import "MHUITableViewStyleGroupedBugController.h"

// MVC&MVVM
#import "SULoginController0.h"
#import "SULoginController1.h"
#import "SULoginController2.h"

@interface MHExampleController () <UITableViewDelegate , UITableViewDataSource>

/** tableView */
@property (nonatomic , weak) UITableView *tableView;

/** examples */
@property (nonatomic , strong) NSMutableArray *examples;


@end

@implementation MHExampleController

- (void)dealloc{
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
    
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - Getter
- (NSMutableArray *)examples{
    if (_examples == nil) {
        
        _examples = [[NSMutableArray alloc] init];
        /**
         一、父子控制器
            1.1 仿百思不得姐
            1.2 仿网易新闻
            1.3 使用YZDisplayViewController框架搭建网易新闻框架 [https://github.com/iThinkerYZ/YZDisplayViewController]
         */
        MHExample *paternityExample = [[MHExample alloc] init];
        paternityExample.header = @"一、父子控制器的使用";
        paternityExample.titles = @[@"1.1 仿百思不得姐",@"1.2 仿网易新闻 ",@"1.3 使用YZDisplayViewController框架搭建网易新闻框架"];
        paternityExample.classes = @[@"MHBuDeJieController",@"MHNetEaseNewsController",@"MHDisplayController"];
        [_examples addObject:paternityExample];
        
        /**
         二、仿微信朋友圈评论回复功能
         1.1 cell里面不嵌套UITableView
         1.2 cell里面嵌套UITableView
         1.3 仿优酷视频的评论回复
         1.4 仿微信朋友圈
         */
        MHExample *commentExample = [[MHExample alloc] init];
        commentExample.header = @"二、微信朋友圈评论回复功能";
        commentExample.titles = @[@"1.1 cell里面不嵌套UITableView",@"1.2 cell里面嵌套UITableView",@"1.3 仿优酷视频的评论回复"];
        commentExample.classes = @[@"MHTopicOneController",@"MHTopicTwoController",@"MHYouKuController"];
        [_examples addObject:commentExample];
        
        
        /**
         三、UITableView常见的使用场景
         1.1 tableView的左滑删除功能
         1.2 tableView的多选删除功能
         1.3 UITableViewStyleGrouped类型下，顶部留白的bug
         */
        MHExample *tableViewExample = [[MHExample alloc] init];
        tableViewExample.header = @"三、UITableView常见的使用场景";
        tableViewExample.titles = @[@"1.1 tableView的左滑删除功能",@"1.2 tableView的多选删除功能",@"1.3 UITableViewStyleGrouped类型下，顶部留白的bug"];
        tableViewExample.classes = @[@"MHDeleteController",@"MHSelectsController",@"MHUITableViewStyleGroupedBugController"];
        [_examples addObject:tableViewExample];
        
        
        /**
         四、MVC&MVVM等设计模式的使用
         1.1 MVC的运用实践
         1.2 MVVM Without ReactiveCococa的运用实践
         1.3 MVVM With ReactiveCococa的运用实践
         */
        MHExample *designPatternsExample = [[MHExample alloc] init];
        designPatternsExample.header = @"四、MVC&MVVM等设计模式的使用";
        designPatternsExample.titles = @[@"1.1 MVC的运用实践",@"1.2 MVVM Without ReactiveCococa的运用实践",@"1.3 MVVM With ReactiveCococa的运用实践"];
        designPatternsExample.classes = @[@"SULoginController0",@"SULoginController1",@"SULoginController2"];
        [_examples addObject:designPatternsExample];
        
        
    }
    return _examples;
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
    tableView.rowHeight = 55;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    MHExample *example = self.examples[indexPath.section];
    cell.textLabel.text = example.titles[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"详情请参照%@",example.classes[indexPath.row]];
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
    /// 这里做个判断
    if ([vcClassString isEqualToString:@"SULoginController1"]) {
        SULoginViewModel1 *viewModel = [[SULoginViewModel1 alloc] initWithParams:@{SUViewModelTitleKey:@"登录"}];
        SULoginController1 *vc = [[SULoginController1 alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([vcClassString isEqualToString:@"SULoginController2"]) {
        SULoginViewModel2 *viewModel = [[SULoginViewModel2 alloc] initWithParams:@{SUViewModelTitleKey:@"登录"}];
        SULoginController2 *vc = [[SULoginController2 alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    UIViewController *vc = [[NSClassFromString(vcClassString) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
