//
//  CMHExample07ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/13.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample07ViewController.h"

@interface CMHExample07ViewController ()
/// textField
@property (nonatomic , readwrite , weak) UITextField *textField;
@end

@implementation CMHExample07ViewController

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

#pragma mark - Override
- (void)configure{
    [super configure];
    
    @weakify(self);
    [[[RACSignal merge:@[RACObserve(self.textField, text),self.textField.rac_textSignal]] distinctUntilChanged]
     subscribeNext:^(NSString * searchText) {
         @strongify(self);
         self.navigationItem.rightBarButtonItem.enabled = MHStringIsNotEmpty(searchText);
    }];
}


#pragma mark - 事件处理Or辅助方法
- (void)_complete:(id)sender{
    
    /// 回调数据
    !self.callback?:self.callback(self.textField.text);

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化
- (void)_setup{
    self.title = @"Example03";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"保存" titleColor:UIColor.whiteColor imageName:nil target:self selector:@selector(_complete:) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    /// 输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"What‘s your name 咯 ？";
    textField.textColor = MHColorFromHexString(@"#333333");
    textField.font = MHRegularFont_16;
    [self.view addSubview:textField];
    self.textField = textField;
    
    
    /// 设置默认值
    self.textField.text = self.params[CMHViewControllerUtilKey];
    
    
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
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(MH_APPLICATION_TOOL_BAR_HEIGHT_44);
       make.top.equalTo(self.view).with.offset(MH_APPLICATION_TOP_BAR_HEIGHT + 16);
    }];
}

#pragma mark - Setter & Getter

@end
