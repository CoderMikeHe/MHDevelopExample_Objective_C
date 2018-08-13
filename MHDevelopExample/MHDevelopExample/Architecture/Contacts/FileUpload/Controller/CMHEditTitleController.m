//
//  CMHEditTitleController.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHEditTitleController.h"
#import "CMHSource.h"
@interface CMHEditTitleController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
/// 资源模型
@property (nonatomic , readwrite , strong) CMHSource *source;
/// editTitle
@property (nonatomic , readwrite , copy) NSString *editTitle;

@end

@implementation CMHEditTitleController

- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [super initWithParams:params]) {
        self.source = params[CMHViewControllerIDKey];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
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
- (void)_complete:(id)sender{
    /// 回调数据
    self.source.title = self.editTitle;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Override
- (void)configure{
    [super configure];
    
    @weakify(self);
    [[[RACSignal merge:@[RACObserve(self.textField, text),self.textField.rac_textSignal]] distinctUntilChanged]
     subscribeNext:^(NSString * text) {
         @strongify(self);
         self.navigationItem.rightBarButtonItem.enabled = MHStringIsNotEmpty(text);
         self.editTitle = text;
     }];
}

#pragma mark - 初始化
- (void)_setup{
    self.textField.text = self.source.title;
    self.editTitle = self.source.title;
    self.title = @"编辑";
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem mh_systemItemWithTitle:@"保存" titleColor:UIColor.whiteColor imageName:nil target:self selector:@selector(_complete:) textType:YES];
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
}

#pragma mark - Setter & Getter

@end
