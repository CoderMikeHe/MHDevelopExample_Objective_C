//
//  CMHExample00ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample00ViewController.h"

@interface CMHExample00ViewController ()

@end

@implementation CMHExample00ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// (是否取消掉当前控制器左滑pop到上一层的功能（栈底控制器无效），NO: 不取消<默认>，YES: 禁止侧滑左侧返回)
        self.interactivePopDisabled = YES;
        
        /// 禁止侧滑场景：
        /// 1. 主要是防止一些当前控制器的手势与侧滑手势冲突，比如图片浏览器，图片贴纸 ...等
        /// 2. 不希望侧滑返回上一层，比如点击右上角返回按钮，返回到根视图
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

#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example00";
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
