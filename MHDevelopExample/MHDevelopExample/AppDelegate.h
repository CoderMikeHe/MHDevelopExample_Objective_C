//
//  AppDelegate.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAccount.h"
#import "MHNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  用户数据 只读
 */
@property (nonatomic, readonly , strong) MHAccount *account;

/**
 *  获取delegate
 *
 */
+ (AppDelegate *)sharedDelegate;
@end

