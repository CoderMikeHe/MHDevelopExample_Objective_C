//
//  CMHInteractiveTransition.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  左侧滑Dissmiss

#import <Foundation/Foundation.h>

@interface CMHInteractiveTransition : UIPercentDrivenInteractiveTransition
/// 是否正在交互
@property (nonatomic, readwrite, assign) BOOL interacting;
/// 记录传进来的VC
- (void)wireToViewController:(UIViewController*)viewController;
@end
