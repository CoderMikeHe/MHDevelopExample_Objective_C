//
//  CMHExample04ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample04ViewController.h"
#import "CMHPingInvertTransition.h"
@interface CMHExample04ViewController ()<UINavigationControllerDelegate>
/// 背景图片
@property (nonatomic , readwrite , weak) UIImageView *bgImageView;

/// 关闭按钮
@property (nonatomic , readwrite , weak) UIButton *closeBtn;

/// 标题
@property (nonatomic , readwrite , weak) UILabel *titleLabel;

@end

@implementation CMHExample04ViewController
/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 去掉导航栏
        self.prefersNavigationBarHidden = YES;
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
- (void)_closeBtnDidClicked:(UIButton *)sender{
    
    self.navigationController.delegate = self;
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        CMHPingInvertTransition *pingInvert = [CMHPingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}



#pragma mark - 初始化
- (void)_setup{
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    
    
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews{

    /// 背景图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self.view addSubview:bgImageView];
    bgImageView.image = MHImageNamed(@"cmh_page_0.jpg");
    self.bgImageView = bgImageView;
    
    /// 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = MHMediumFont(18.0f);
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.text = @"Example04";
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /// 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:MHImageNamed(@"cmh_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(_closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(self.view).with.offset(CMHTopMargin(24));
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.left.equalTo(self.view).with.offset(20);
        make.centerY.equalTo(self.closeBtn);
    }];
}

#pragma mark - Setter & Getter

@end
