//
//  CMHExample02ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample02ViewController.h"

@interface CMHExample02ViewController ()
/// topToolbar
@property (nonatomic , readwrite , weak) UIView *topToolbar;
/// 开关
@property (nonatomic , readwrite , weak) UISwitch *sw;
/// 关闭按钮
@property (nonatomic , readwrite , weak) UIButton *closeBtn;
@end

@implementation CMHExample02ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 隐藏（YES）导航栏底部细线
        self.prefersNavigationBarBottomLineHidden = YES;
        
        /// 隐藏导航栏场景
        /// 1. 具体看自己项目产品的UI..嘻嘻。
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
    self.title = @"Example02";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
    UIView *topToolbar = [[UIView alloc] init];
    topToolbar.backgroundColor = [UIColor whiteColor];
    self.topToolbar = topToolbar;
    [self.view addSubview:topToolbar];
    
    UISwitch *sw = [[UISwitch alloc] init];
    [sw setOn:YES animated:YES];
    [topToolbar addSubview:sw];
    self.sw = sw;
    
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.topToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(MH_APPLICATION_TOP_BAR_HEIGHT);
        make.height.mas_equalTo(MH_APPLICATION_TOOL_BAR_HEIGHT_49);
    }];
    
    [self.sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topToolbar);
    }];
    
}

#pragma mark - Setter & Getter

@end
