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


#if defined(DEBUG)||defined(_DEBUG)
#import "JPFPSStatus.h"
#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#import "CacheCleanerPlugin.h"
#import "RetainCycleLoggerPlugin.h"
#endif


@interface AppDelegate ()
/**
 *  用户数据 只读
 */
@property (nonatomic, readwrite, strong) MHAccount *account;


@end

@implementation AppDelegate
{
#if defined(DEBUG)||defined(_DEBUG)
    FBMemoryProfiler *memoryProfiler;
#endif
}

#pragma mark- 获取appdelegate
+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (MHAccount *)account
{
    if (_account == nil) {
        // 内部初始化了数据
        _account = [[MHAccount alloc] init];
    }
    return _account;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置状态栏不隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MHNavigationController alloc] initWithRootViewController:[[MHExampleController alloc] init]];
    [self.window makeKeyAndVisible];
    
#if defined(DEBUG)||defined(_DEBUG)
    [self _configDebugModelTools];
#endif
    
    return YES;
}


#pragma mark - 调试(DEBUG)模式
- (void)_configDebugModelTools
{
    /// 显示FPS
    [[JPFPSStatus sharedInstance] open];
    
    /// 内存分析+通过Runtime监测循环引用+跟踪oc对象的分配情况
    NSArray *filters = @[FBFilterBlockWithObjectIvarRelation([UIView class], @"_subviewCache"),
                         FBFilterBlockWithObjectIvarRelation([UIPanGestureRecognizer class], @"_internalActiveTouches")];
    FBObjectGraphConfiguration *configuration =
    [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:filters
                                         shouldInspectTimers:NO];
    memoryProfiler = [[FBMemoryProfiler alloc] initWithPlugins:@[[CacheCleanerPlugin new],
                                                                 [RetainCycleLoggerPlugin new]]
                              retainCycleDetectorConfiguration:configuration];
    [memoryProfiler enable];
}


@end
