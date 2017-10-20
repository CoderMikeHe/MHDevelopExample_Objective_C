//
//  SULoginController0.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SULoginController0.h"
#import "SULoginInputView.h"
#import "SUGoodsController0.h"

@interface SULoginController0 ()
/// 输入款的父类
@property (weak, nonatomic) IBOutlet UIView *inputBaseView;

/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/// 输入框
@property (nonatomic, readwrite, weak) SULoginInputView *inputView;
/// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;



@end

@implementation SULoginController0

/////// ========== 产品🐶的需求 程序🦍的命运 ==========
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [(MHNavigationController *)self.navigationController hideNavgationSystemLine];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [(MHNavigationController *)self.navigationController showNavgationSystemLine];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /// 弹出键盘
//    [self.inputView.phoneTextField becomeFirstResponder];
}
/////// ========== 产品🐶的需求 程序🦍的命运 ==========

- (void)dealloc{
    MHDealloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";

    /// 初始化导航栏
    [self _setupNavigationItem];

    
    
    
    /// 初始化subView
    [self _setupSubViews];
    
}

////////////////// 以下为逻辑代码，还请过多关注 ///////////////////
#pragma mark - 事件处理
/// 登录按钮被点击
- (IBAction)_loginBtnDidClicked:(UIButton *)sender {
    
    /// 验证手机号码 正确的手机号码
    if (![NSString mh_isValidMobile:self.inputView.phoneTextField.text]){
        [MBProgressHUD mh_showTips:@"请输入正确的手机号码"];
        return;
    }
    
    /// 验证验证码 四位数字
    if (![NSString mh_isPureDigitCharacters:self.inputView.verifyTextField.text] || self.inputView.verifyTextField.text.length != 4 ) {
        [MBProgressHUD mh_showTips:@"验证码错误"];
        return;
    }
    
    //// 键盘掉下
    [self.view endEditing:YES];
    
    /// show loading
    [MBProgressHUD mh_showProgressHUD:@"Loading..."];
    
    /// 发起请求 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// hid hud
        [MBProgressHUD mh_hideHUD];
        
        /// 登录成功 保存数据 简单起见 随便存了哈
        [[NSUserDefaults standardUserDefaults] setValue:self.inputView.phoneTextField.text forKey:SULoginPhoneKey0];
        [[NSUserDefaults standardUserDefaults] setValue:self.inputView.verifyTextField.text forKey:SULoginVerifyCodeKey0];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /// 保存用户数据 这个逻辑就不要我来实现了吧 假数据参照 [AppDelegate sharedDelegate].account
        
        /// 跳转主界面
        SUGoodsController0 *goodsVc = [[SUGoodsController0 alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:goodsVc animated:YES];
    });
    
}
/// textField的数据改变
- (void)_textFieldValueDidChanged:(UITextField *)sender
{
    self.loginBtn.enabled = (self.inputView.phoneTextField.hasText && self.inputView.verifyTextField.hasText);
    
    /// 这里是假数据 模拟用户输入去本地数据库拉去数据
    if(![NSString mh_isValidMobile:self.inputView.phoneTextField.text])
    {
        self.userAvatar.image = placeholderUserIcon();
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = [NSString mh_isValidMobile:self.inputView.phoneTextField.text]?[AppDelegate sharedDelegate].account.avatarUrl:nil;
        [MHWebImageTool setImageWithURL:urlStr placeholderImage:placeholderUserIcon() imageView:self.userAvatar];
    });
}

/// 填充数据
- (void)_fillupTextField
{
    self.inputView.phoneTextField.text = @"13874389438";
    self.inputView.verifyTextField.text = @"3838";
    /// 验证登录按钮的有效性
    [self _textFieldValueDidChanged:nil];
}










////////////////// 以下为UI代码，不必过多关注 ///////////////////
#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    /// 快捷方式 填充数据
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填充" style:UIBarButtonItemStylePlain target:self action:@selector(_fillupTextField)];
}


#pragma mark - 初始化subView
- (void)_setupSubViews
{
    /// 设置圆角
    [self.userAvatar zy_cornerRadiusRoundingRect];
    [self.userAvatar zy_attachBorderWidth:.5f color:MHColorFromHexString(@"#EBEBEB")];
    
    /// 输入框
    SULoginInputView *inputView = [SULoginInputView inputView];
    self.inputView = inputView;
    [self.inputBaseView addSubview:inputView];
    
    /// 布局
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    /// 登录按钮
    [self.loginBtn setTitleColor:MHAlphaColor(255.0f, 255.0f, 255.0f, .5f) forState:UIControlStateDisabled];
    /// 从沙盒中取出数据
    inputView.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SULoginPhoneKey0];
    inputView.verifyTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SULoginVerifyCodeKey0];
    /// 验证登录按钮的有效性
    [self _textFieldValueDidChanged:nil];
    
    /// 添加事件
    [inputView.phoneTextField addTarget:self action:@selector(_textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [inputView.verifyTextField addTarget:self action:@selector(_textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - Override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /// 键盘掉下
    [self.view endEditing:YES];
}
@end
