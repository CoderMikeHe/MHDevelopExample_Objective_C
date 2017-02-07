//
//  MHDisplayController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHDisplayController.h"
#import "MHTopicController.h"

@interface MHDisplayController ()

@end

@implementation MHDisplayController

- (void)dealloc
{
    MHDealloc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 初始化数据
    [self _setupData];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
    // 监听通知中心
    [self _addNotificationCenter];
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - 初始化
- (void)_setup
{
    self.view.backgroundColor = MHColor(223, 223, 223);
    
    self.fd_interactivePopDisabled = YES;
    
    // KVC
    [self setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forKeyPath:@"titleScrollViewColor"];
    
    // 设置titleLabel的属性
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        *titleScrollViewColor = [MHGlobalGrayBackgroundColor colorWithAlphaComponent:0.7]; // 目前这个不起作用 利用KVC
        *titleFont = [UIFont systemFontOfSize:15.0f];
    }];
    
    // 标题渐变
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = MHGlobalBlackTextColor;
        *selColor = MHGlobalOrangeTextColor;
    }];
    
    
    // 下划线属性配置
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        *underLineColor = MHGlobalOrangeTextColor;
        *isUnderLineDelayScroll = NO;
        *isUnderLineEqualTitleWidth = YES;
    }];

    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域
    self.isfullScreen = YES;
}

#pragma mark - 初始化数据
- (void)_setupData
{
    // 模仿网络延迟，0.2秒后，才知道有多少标题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 移除之前所有子控制器
        [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        
        // 把对应标题保存到控制器中，并且成为子控制器，才能刷新
        // 添加所有新的子控制器
        [self _setupAllChildViewController];
        
        // 注意：必须先确定子控制器
        [self refreshDisplay];
        
    });
}

#pragma mark - 设置自控制器
- (void)_setupAllChildViewController
{
    MHTopicController *all = [[MHTopicController alloc] init];
    all.title = @"全部";
    [self addChildViewController:all];
    
    MHTopicController *video = [[MHTopicController alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    MHTopicController *voice = [[MHTopicController alloc] init];
    voice.title = @"声音";
    [self addChildViewController:voice];
    
    MHTopicController *picture = [[MHTopicController alloc] init];
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    MHTopicController *word = [[MHTopicController alloc] init];
    word.title = @"段子";
    [self addChildViewController:word];
    
    
    MHTopicController *military = [[MHTopicController alloc] init];
    military.title = @"军事";
    [self addChildViewController:military];
    
    MHTopicController *science = [[MHTopicController alloc] init];
    science.title = @"科技";
    [self addChildViewController:science];
}


#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    // 搜索
    self.title = @"YZDisplayViewController";
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    
}

#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}


@end
