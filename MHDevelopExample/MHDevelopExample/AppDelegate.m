//
//  AppDelegate.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "AppDelegate.h"
#import "MHNavigationController.h"
#import "MHExampleController.h"
#import "CMHHomePageViewController.h"

#if defined(DEBUG)||defined(_DEBUG)
#import "JPFPSStatus.h"
#endif

@interface AppDelegate ()
/**
 *  用户数据 只读
 */
@property (nonatomic, readwrite, strong) MHAccount *account;


@end

@implementation AppDelegate

#pragma mark- 获取appdelegate
+ (AppDelegate *)sharedDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (MHAccount *)account{
    if (_account == nil) {
        // 内部初始化了数据
        _account = [[MHAccount alloc] init];
    }
    return _account;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 初始化UI之前配置
    [self _configureApplication:application initialParamsBeforeInitUI:launchOptions];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
#if CMHDEBUG
    self.window.rootViewController = [[CMHHomePageViewController alloc] initWithParams:nil];
#else
    self.window.rootViewController = [[MHNavigationController alloc] initWithRootViewController:[[MHExampleController alloc] init]];
#endif
    
    
    [self.window makeKeyAndVisible];
    
    

#if defined(DEBUG)||defined(_DEBUG)
//    [self _configDebugModelTools];
#endif
    
    return YES;
}


#pragma mark - 在初始化UI之前配置
- (void)_configureApplication:(UIApplication *)application initialParamsBeforeInitUI:(NSDictionary *)launchOptions{
    /// 显示状态栏
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    /// 配置键盘
    [self _configureKeyboardManager];
    
    // 配置YYWebImage
    [self _configureYYWebImage];
    
    /// 配置网络请求
    [CMHHTTPService sharedInstance];
}

/// 配置键盘管理器
- (void)_configureKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
}

/// 配置YYWebImage
- (void)_configureYYWebImage {
    /// CoderMikeHe Fixed Bug : 解决 SDWebImage & YYWebImage 加载不出http://img3.imgtn.bdimg.com/it/u=965183317,1784857244&fm=27&gp=0.jpg的BUG
    NSMutableDictionary *header = [YYWebImageManager sharedManager].headers.mutableCopy;
    header[@"User-Agent"] = @"iPhone"; 
    [YYWebImageManager sharedManager].headers = header;
}

#pragma mark - 调试(DEBUG)模式
- (void)_configDebugModelTools{
    /// 显示FPS
    [[JPFPSStatus sharedInstance] open];
    
}


@end
