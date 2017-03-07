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



@interface AppDelegate ()
/**
 *  用户数据 只读
 */
@property (nonatomic , strong) MHAccount *account;



@end

@implementation AppDelegate


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
    [[JPFPSStatus sharedInstance] open];
#endif
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
