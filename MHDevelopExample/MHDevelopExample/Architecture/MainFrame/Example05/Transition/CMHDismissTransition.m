//
//  CMHDismissTransition.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHDismissTransition.h"
#import "CMHViewController.h"
@implementation CMHDismissTransition
// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return .5f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    /// 设置窗口颜色
    AppDelegate.sharedDelegate.window.backgroundColor = [UIColor blackColor];
    
    /// 获取控制器
    CMHViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CMHViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    /// 获取动画时间
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    /// 设置toViewController的原始位置
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect finalFrame = CGRectOffset(initialFrame, 0, MH_SCREEN_BOUNDS.size.height);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    /// 加一个蒙版
    UIView *toWrapperView = [[UIView alloc] initWithFrame:containerView.bounds];
    /// 设置蒙版颜色 .5f ~ .0f
    toWrapperView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    [containerView addSubview:toWrapperView];
    [containerView bringSubviewToFront:fromViewController.view];
    
    
    /// 缩小尺寸
    toViewController.view.transform = CGAffineTransformMakeScale(0.98, 0.98);
    
    /// 开启一个动画
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toViewController.view.transform = CGAffineTransformIdentity;
                         toWrapperView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.0f];
                         fromViewController.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished) {
                         /// 设置窗口颜色
                         AppDelegate.sharedDelegate.window.backgroundColor = [UIColor whiteColor];
                         [toWrapperView removeFromSuperview];
                         /// 5. Tell context that we completed.
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}
@end
