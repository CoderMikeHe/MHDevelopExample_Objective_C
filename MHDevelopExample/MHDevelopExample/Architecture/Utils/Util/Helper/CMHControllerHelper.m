//
//  CMHControllerHelper.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/7.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHControllerHelper.h"
#import "CMHHomePageViewController.h"
@implementation CMHControllerHelper
+ (UIViewController *)currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    /// CoderMikeHe Fixed BUG: 这里必须要判断一下，否则取出来永远都是 MHHomePageViewController。这是架构上小缺(特)陷(性)。因为MHHomePageViewController的子控制器是UITabBarController，所以需要递归UITabBarController的所有的子控制器
    if ([resultVC isKindOfClass:[CMHHomePageViewController class]]) {
        CMHHomePageViewController *mainVc = (CMHHomePageViewController *)resultVC;
        resultVC = [self _topViewController:mainVc.tabBarController];
    }
    
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}
@end
