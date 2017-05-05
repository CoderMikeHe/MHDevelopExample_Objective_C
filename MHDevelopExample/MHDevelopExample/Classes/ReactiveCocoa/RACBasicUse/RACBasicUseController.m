//
//  RACBasicUseController.m
//  MHDevelopExample
//
//  Created by senba on 2017/4/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "RACBasicUseController.h"

@interface RACBasicUseController ()

@end

@implementation RACBasicUseController

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
    
    // 设置通知
    [self _addNotificationCenter];
    
}
#pragma mark ------------ 公共方法


#pragma mark ------------ 私有方法
#pragma mark - Getter


#pragma mark - 初始化
- (void)_setup
{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"";
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    
    
}

#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}



@end
