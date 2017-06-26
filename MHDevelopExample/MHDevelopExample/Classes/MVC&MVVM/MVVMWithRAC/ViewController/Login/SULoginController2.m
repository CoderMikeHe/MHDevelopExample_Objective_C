//
//  SULoginController2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的登录控制器 -- C

#import "SULoginController2.h"
#import "SULoginInputView.h"
#import "SUGoodsController2.h"

@interface SULoginController2 ()
/// 输入款的父类
@property (weak, nonatomic) IBOutlet UIView *inputBaseView;
/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/// 输入框
@property (nonatomic, readwrite, weak) SULoginInputView *inputView;
/// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
/// 模型视图
@property (nonatomic, readonly, strong) SULoginViewModel2 *viewModel;

@end

@implementation SULoginController2

@dynamic viewModel;
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
    [self.inputView.phoneTextField becomeFirstResponder];
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
}


/// binding viewModel
- (void)bindViewModel
{   
    [super bindViewModel];
    
    @weakify(self);
    
    /// 判定数据
    [RACObserve(self.viewModel, avatarUrlString) subscribeNext:^(NSString *avatarUrlString) {
        @strongify(self);
        [MHWebImageTool setImageWithURL:avatarUrlString placeholderImage:placeholderUserIcon() imageView:self.userAvatar];
    }];
   
/***
    /// Fixed：rac_textSignal只有用户输入才有效，如果只是直接赋值 eg:self.inputView.phoneTextField.text = @"xxxx"  这样self.inputView.phoneTextField.rac_textSignal就不会触发的。
    /// 解决办法：利用 RACObserve 来观察self.inputView.phoneTextField.text的赋值办法即可
    /// 用户输入的情况 触发rac_textSignal
    /// 用户非输入而是直接赋值的情况 触发RACObserve
 
    RAC(self.viewModel , mobilePhone) = self.inputView.phoneTextField.rac_textSignal;
    RAC(self.viewModel , verifyCode) = self.inputView.verifyTextField.rac_textSignal;
**/
    RAC(self.viewModel , mobilePhone) = [RACSignal merge:@[RACObserve(self.inputView.phoneTextField, text),self.inputView.phoneTextField.rac_textSignal]];
    RAC(self.viewModel , verifyCode) = [RACSignal merge:@[RACObserve(self.inputView.verifyTextField, text),self.inputView.verifyTextField.rac_textSignal]];
    
    RAC(self.loginBtn , enabled) = self.viewModel.validLoginSignal;

    /// 登录按钮点击
    /** 切记：如果这样写会崩溃：原因是 一个对象只能绑定一个RACDynamicSignal的信号
        RAC(self.loginBtn , enabled) = self.viewModel.validLoginSignal;
        self.loginBtn.rac_command = self.viewModel.loginCommand;
        reason：'Signal <RACDynamicSignal: 0x60800023d3e0> name:  is already bound to key path "enabled" on object <UIButton: 0x7f8448c57690; frame = (12 362; 351 49); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x60800023dae0>>, adding signal <RACReplaySubject: 0x60000027ce00> name:  is undefined behavior'
    */
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     doNext:^(id x) {
         @strongify(self);
         [self.view endEditing:YES];
         [MBProgressHUD mh_showProgressHUD:@"Loading..."];
     }]
     subscribeNext:^(UIButton *sender) {
         @strongify(self);
         [self.viewModel.loginCommand execute:nil];
     }];
    
    /// 数据成功
    [self.viewModel.loginCommand.executionSignals.switchToLatest
     subscribeNext:^(id x) {
         @strongify(self);
         [MBProgressHUD mh_hideHUD];
         /// 跳转
         SUGoodsViewModel2 *viewModel = [[SUGoodsViewModel2 alloc] initWithParams:@{}];
         SUGoodsController2 *goodsVc = [[SUGoodsController2 alloc] initWithViewModel:viewModel];
         [self.navigationController pushViewController:goodsVc animated:YES];
    }];
    
    /// 错误信息
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        /// 处理验证错误的error
        if ([error.domain isEqualToString:SUCommandErrorDomain]) {
            [MBProgressHUD mh_showTips:error.userInfo[SUCommandErrorUserInfoKey]];
            return ;
        }
        [MBProgressHUD mh_showErrorTips:error];
    }];
}

////////////////// 以下为UI代码，不必过多关注 ///////////////////
#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    /// 快捷方式 填充数据
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填充" style:UIBarButtonItemStylePlain target:nil action:nil];
    /// 填充按钮点击
    @weakify(self);
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.inputView.phoneTextField.text = @"13874389438";
        self.inputView.verifyTextField.text = @"5858";
        return [RACSignal empty];
    }];
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
    inputView.phoneTextField.text =  [[NSUserDefaults standardUserDefaults] objectForKey:SULoginPhoneKey2];
    inputView.verifyTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:SULoginVerifyCodeKey2];

}

#pragma mark - Override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /// 键盘掉下
    [self.view endEditing:YES];
}

@end
