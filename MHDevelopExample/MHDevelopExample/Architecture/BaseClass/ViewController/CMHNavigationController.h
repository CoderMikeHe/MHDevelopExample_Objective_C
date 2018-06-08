//
//  CMHNavigationController.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  所有自定义导航栏视图控制器的基类

#import <UIKit/UIKit.h>

@interface CMHNavigationController : UINavigationController
/// 显示导航栏的细线
- (void)showNavigationBottomLine;
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine;
@end
