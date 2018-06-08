//
//  CMHExample05ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample05ViewController.h"

@interface CMHExample05ViewController ()

@end

@implementation CMHExample05ViewController

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
- (void)_closeAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example05";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:nil titleColor:nil imageName:@"off_white" target:self selector:@selector(_closeAction) textType:NO];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter


@end
