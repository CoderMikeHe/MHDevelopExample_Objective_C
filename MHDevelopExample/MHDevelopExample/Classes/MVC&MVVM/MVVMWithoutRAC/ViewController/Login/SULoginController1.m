//
//  SULoginController1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SULoginController1.h"
#import "SULoginInputView.h"
#import "SUGoodsController1.h"

@interface SULoginController1 ()
/// 输入款的父类
@property (weak, nonatomic) IBOutlet UIView *inputBaseView;

/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

/// 输入框
@property (nonatomic, readwrite, weak) SULoginInputView *inputView;
/// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
/// 模型视图
@property (nonatomic, readonly, strong) SULoginViewModel1 *viewModel;
@end
@implementation SULoginController1
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}
@dynamic viewModel;

/////// ========== 产品🐶的需求 程序🦍的命运 ==========
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [(MHNavigationController *)self.navigationController hideNavgationSystemLine];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /// 弹出键盘
    [self.inputView.phoneTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [(MHNavigationController *)self.navigationController showNavgationSystemLine];
    
}


/////// ========== 产品🐶的需求 程序🦍的命运 ==========


- (void)dealloc{
    MHDealloc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化导航栏
    [self _setupNavigationItem];
    
    /// 初始化subView
    [self _setupSubViews];

    /// bind data
    [self _bindViewModel];
}

#pragma mark - 事件处理
/// 登录按钮的点击事件
- (IBAction)_loginBtnDidClicked:(UIButton *)sender {
    /// 数据验证的在Controller中处理 否则的话 viewModel 中就引用了 view了
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
    @weakify(self);
    [self.viewModel loginSuccess:^(id json) {
        @strongify(self);
        [MBProgressHUD mh_hideHUD];
        /// 跳转
        SUGoodsViewModel1 *viewModel = [[SUGoodsViewModel1 alloc] initWithParams:@{}];
        SUGoodsController1 *goodsVc = [[SUGoodsController1 alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:goodsVc animated:YES];
    } failure:nil];
}

/// textField的数据改变
- (void)_textFieldValueDidChanged:(UITextField *)sender
{
    /// bind data
    self.viewModel.mobilePhone = self.inputView.phoneTextField.text;
    self.viewModel.verifyCode = self.inputView.verifyTextField.text;
    self.loginBtn.enabled = self.viewModel.validLogin;
    
}

/// 填充数据 Just To Debug
- (void)_fillupTextField
{
    self.inputView.phoneTextField.text = @"13874385438";
    self.inputView.verifyTextField.text = @"4848";
    /// 验证登录按钮的有效性
    [self _textFieldValueDidChanged:nil];
}

#pragma mark - BindModel
- (void)_bindViewModel
{
    /// kvo
    _KVOController = [FBKVOController controllerWithObserver:self];
    
    @weakify(self);
    /// binding self.viewModel.avatarUrlString
    [_KVOController mh_observe:self.viewModel keyPath:@"avatarUrlString" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        [MHWebImageTool setImageWithURL:change[NSKeyValueChangeNewKey] placeholderImage:placeholderUserIcon() imageView:self.userAvatar];
    }];
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
    inputView.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SULoginPhoneKey1];
    inputView.verifyTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SULoginVerifyCodeKey1];
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
