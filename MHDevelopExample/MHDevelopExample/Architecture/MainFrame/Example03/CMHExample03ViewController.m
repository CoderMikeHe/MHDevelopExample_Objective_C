//
//  CMHExample03ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample03ViewController.h"

@interface CMHExample03ViewController ()
/// textField
@property (nonatomic , readwrite , weak) UITextField *textField;
@end

@implementation CMHExample03ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /// 以下属性，配置配置，跑一下便知
        
        /// 是否允许 IQKeyboardManager管理键盘 。默认是YES
        self.keyboardEnable = YES;
        /// 是否允许点击输入框外部区，使得键盘掉下默认是10
        self.shouldResignOnTouchOutside = YES;
        /// 键盘顶部距离当前响应的textField的底部的距离，默认是10.0f，前提得 `keyboardEnable = YES` 且数值不得小于 0。
        self.keyboardDistanceFromTextField = 40;
        
        
        /// Tips：键盘这块的逻辑处理，具体看自己的产品需求，当然IQKeyboardManager 还有许多牛逼且好用功能需要大家去探索和使用
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
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
    self.title = @"Example03";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"说出你的梦想...";
    textField.textColor = MHColorFromHexString(@"#333333");
    textField.font = MHRegularFont_16;
    [self.view addSubview:textField];
    self.textField = textField;
    
    textField.layer.cornerRadius = 10;
    textField.layer.masksToBounds = YES;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, MH_APPLICATION_TOOL_BAR_HEIGHT_44)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(MH_APPLICATION_TOOL_BAR_HEIGHT_44);
        make.centerY.equalTo(self.view).with.offset(100);
    }];
}

#pragma mark - Setter & Getter

@end
