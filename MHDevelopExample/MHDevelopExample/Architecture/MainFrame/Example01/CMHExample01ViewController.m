//
//  CMHExample01ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample01ViewController.h"

@interface CMHExample01ViewController ()
/// topToolbar
@property (nonatomic , readwrite , weak) UIView *topToolbar;
/// 开关
@property (nonatomic , readwrite , weak) UISwitch *sw;
/// 关闭按钮
@property (nonatomic , readwrite , weak) UIButton *closeBtn;
@end

@implementation CMHExample01ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 隐藏（YES）导航栏
        self.prefersNavigationBarHidden = YES;
        
        /// 隐藏导航栏场景
        /// 1. 自定义导航栏
        /// 2. 就是不想要导航栏，咋地
        /// 3. ...
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
- (void)_closeAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example01";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    UIView *topToolbar = [[UIView alloc] init];
    topToolbar.backgroundColor = [UIColor pinkColor];
    self.topToolbar = topToolbar;
    [self.view addSubview:topToolbar];
    
    UISwitch *sw = [[UISwitch alloc] init];
    [sw setOn:YES animated:YES];
    [topToolbar addSubview:sw];
    self.sw = sw;
    
    /// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:MHImageNamed(@"cmh_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(_closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
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
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(self.view).with.offset(CMHTopMargin(24));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
}


#pragma mark - Setter & Getter
@end
