//
//  CMHMainFrameViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
// 

#import "CMHMainFrameViewController.h"
#import "CMHExampleCell.h"
#import "CMHExample.h"
#import "CMHProfileButton.h"
#import "CMHNavigationController.h"

/// 是否禁止侧滑返回
#import "CMHExample00ViewController.h"
/// 是否隐藏导航栏
#import "CMHExample01ViewController.h"
/// 是否隐藏导航栏底部细线
#import "CMHExample02ViewController.h"
/// 键盘处理相关
#import "CMHExample03ViewController.h"
/// 过渡动画相关 <Ping>
#import "CMHExample04ViewController.h"
/// 过渡动画相关 <Move>
#import "CMHExample05ViewController.h"
/// Ping过渡动画
#import "CMHPingTransition.h"
/// Present过渡动画
#import "CMHPresentTransition.h"
/// Dismiss过渡动画
#import "CMHDismissTransition.h"
/// 侧滑Dismiss
#import "CMHInteractiveTransition.h"
/// 基类提供的方法
#import "CMHExample06ViewController.h"
/// 测试回调
#import "CMHExample07ViewController.h"


@interface CMHMainFrameViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
/// 个人中心按钮
@property (nonatomic , readwrite , strong) CMHProfileButton *profileBtn;

/// 侧滑Dismiss
@property (nonatomic , readwrite , strong) CMHInteractiveTransition *interactiveDissmiss;


/// 你的名字
@property (nonatomic , readwrite , copy) NSString *name;


@end

@implementation CMHMainFrameViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT+16, 0, 0, 0);
}

- (void)configure{
    [super configure];
    
    /// 配置一些数据 <测试代码>
    
    CMHExample *example00 = [[CMHExample alloc] init];
    example00.title = @"00：禁止侧滑返回";
    example00.subtitle = @"interactivePopDisabled = YES";
    example00.destClass = [CMHExample00ViewController class];
    [self.dataSource addObject:example00];
    
    
    CMHExample *example01 = [[CMHExample alloc] initWithTitle:@"01：隐藏导航栏" subtitle:@"prefersNavigationBarHidden = YES"];
    example01.destClass = [CMHExample01ViewController class];
    [self.dataSource addObject:example01];
    
    
    CMHExample *example02 = [[CMHExample alloc] initWithTitle:@"02：隐藏导航栏底部的细线" subtitle:@"prefersNavigationBarBottomLineHidden = YES"];
    example02.destClass = [CMHExample02ViewController class];
    [self.dataSource addObject:example02];
    
    
    CMHExample *example03 = [[CMHExample alloc] initWithTitle:@"03：键盘处理相关配置" subtitle:@"[keyboardEnable]、[shouldResignOnTouchOutside]、[keyboardDistanceFromTextField]"];
    example03.destClass = [CMHExample03ViewController class];
    [self.dataSource addObject:example03];
    
    CMHExample *example05 = [[CMHExample alloc] initWithTitle:@"05：Present/Dismiss转场动画" subtitle:@"Present、Dismiss、侧滑Dismiss"];
    @weakify(self);
    example05.operation = ^{
       @strongify(self);
        CMHExample05ViewController *example05 = [[CMHExample05ViewController alloc] initWithParams:nil];
        CMHNavigationController *example05Nav = [[CMHNavigationController alloc] initWithRootViewController:example05];
        [self.interactiveDissmiss wireToViewController:example05Nav];
        example05Nav.transitioningDelegate = self;
        [self presentViewController:example05Nav animated:YES completion:NULL];
    };
    [self.dataSource addObject:example05];
    
    
    CMHExample *example06 = [[CMHExample alloc] initWithTitle:@"06：测试基类提供的API" subtitle:@"[requestRemoteData]、[configure]、[fetchLocalData]"];
    example06.destClass = [CMHExample06ViewController class];
    [self.dataSource addObject:example06];
    
    
    CMHExample *example07 = [[CMHExample alloc] initWithTitle:@"07：反向回调数据" subtitle:@"void (^callback)(id);"];
    example07.operation = ^{
        @strongify(self);
        NSDictionary *param = MHStringIsNotEmpty(self.name)?@{CMHViewControllerUtilKey:self.name}:nil;
        CMHExample07ViewController *vc = [[CMHExample07ViewController alloc] initWithParams:param];
        [self.navigationController pushViewController:vc animated:YES];
        
        /// 设置回调
        @weakify(self);
        vc.callback = ^(NSString *name) {
            @strongify(self);
            self.name = name;
            [MBProgressHUD mh_showTips:[NSString stringWithFormat:@"你的名字叫 -- %@",name] addedToView:self.view];
        };
        
    };
    [self.dataSource addObject:example07];
    
    /// 刷洗数据
//    [self.tableView reloadData]; /// 等效下面的方法
    [self reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    /// 生成一个cell
    return [CMHExampleCell cellWithTableView:tableView];
}

/// 为Cell配置某个
- (void)configureCell:(CMHExampleCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    /// 为cell配置一个数据模型
    [cell configureModel:object];
}

#pragma mark - 事件处理Or辅助方法
- (void)_profileBtnDidClciked:(UIButton *)sender{
    
    /// 设置动画
    self.navigationController.delegate = self;
    CMHExample04ViewController *example04 = [[CMHExample04ViewController alloc] initWithParams:nil];
    [self.navigationController pushViewController:example04 animated:YES];
}


#pragma mark - 事件处理
- (void)_goHome{
    /// 发通知
    [MHNotificationCenter postNotificationName:MHSwitchRootViewControllerNotification object:nil userInfo:@{MHSwitchRootViewControllerUserInfoKey: @(MHSwitchToRootTypeDefault)}];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMHExample *example = self.dataSource[indexPath.row];
    
    if (example.operation) {  /// 如果有对应操作，则执行操作，优先级高于 destClass
        /// 执行操作
        example.operation();
        
        return;
    }
    
    if (example.destClass) {
        CMHViewController *destViewController = [[example.destClass alloc] init];
        [self.navigationController pushViewController:destViewController animated:YES];
    }
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    /// 过滤一下下
    if (![toVC isKindOfClass:CMHExample04ViewController.class]) {
        return nil;
    }
    if (operation == UINavigationControllerOperationPush) {
        CMHPingTransition *ping = [[CMHPingTransition alloc] init];
        return ping;
    }
    
    return nil;
    
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [CMHPresentTransition new];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [CMHDismissTransition new];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveDissmiss.interacting ? self.interactiveDissmiss : nil;
}


#pragma mark - 初始化
- (void)_setup{
    self.navigationItem.title = @"CMHViewController";
    self.tableView.rowHeight = 71;
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    /// 设置个人中心
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.profileBtn];
    
    /// 添加按钮
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"tabbar_home"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"tabbar_home_selected"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 43, 44);
    // 监听按钮点击
    [button addTarget:self action:@selector(_goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{

}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{

}

#pragma mark - Setter & Getter
- (CMHProfileButton *)profileBtn{  /// 44 X 44
    if (_profileBtn == nil) {
        /// profileBtn
        /// CoderMikeHe Fixed Bug :
        /// 这里不能用系统的UIButton，否则我们即使设置了按钮的固定大小，到时候展示网络图片的时候，按钮大小会跟随图片大小，解决方案：详见`CMHProfileButton`
        _profileBtn = [[CMHProfileButton alloc] init];
        [_profileBtn setImage:MHImageNamed(@"avata_default_my") forState:UIControlStateNormal];
        [_profileBtn yy_setImageWithURL:[NSURL URLWithString:@"http://tva3.sinaimg.cn/crop.0.6.264.264.180/93276e1fjw8f5c6ob1pmpj207g07jaa5.jpg"] forState:UIControlStateNormal placeholder:MHImageNamed(@"fts_default_headimage_36x36") options:CMHWebImageOptionAutomatic completion:NULL];
        _profileBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_profileBtn addTarget:self action:@selector(_profileBtnDidClciked:) forControlEvents:UIControlEventTouchUpInside];
        [_profileBtn sizeToFit];
    }
    return _profileBtn;
}


- (CMHInteractiveTransition *)interactiveDissmiss{
    if (_interactiveDissmiss == nil) {
        _interactiveDissmiss  = [[CMHInteractiveTransition alloc] init];
    }
    return _interactiveDissmiss ;
}
@end
