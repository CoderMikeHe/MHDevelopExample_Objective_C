//
//  CMHPresentTransition.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHPresentTransition.h"
#import "CMHViewController.h"
@implementation CMHPresentTransition
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
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(finalFrame, 0, MH_SCREEN_BOUNDS.size.height);
    
    // 3. Add toVC's view to containerView
    UIView *containerView = [transitionContext containerView];
    
    /// 加一个蒙版
    UIView *fromWrapperView = [[UIView alloc] initWithFrame:containerView.bounds];
    /// 设置蒙版颜色 .0f~ .5f
    fromWrapperView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.0f];
    [containerView insertSubview:fromWrapperView aboveSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    
    /// 开启一个动画
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         fromWrapperView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
                         /// 缩小尺寸
                         fromViewController.view.transform = CGAffineTransformMakeScale(0.98, 0.98);
                         
                         toViewController.view.frame = finalFrame;
                         
                     }
                     completion:^(BOOL finished) {
                         /// 设置窗口颜色
                         AppDelegate.sharedDelegate.window.backgroundColor = [UIColor whiteColor];
                         /// 置位
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         
                         // 5. Tell context that we completed.
                         [fromWrapperView removeFromSuperview];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}
@end
