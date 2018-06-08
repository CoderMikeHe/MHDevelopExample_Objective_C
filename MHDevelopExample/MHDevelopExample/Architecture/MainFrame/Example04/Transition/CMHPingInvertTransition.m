//
//  CMHPingInvertTransition.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHPingInvertTransition.h"
#import "CMHMainFrameViewController.h"
#import "CMHExample04ViewController.h"

@interface CMHPingInvertTransition()<CAAnimationDelegate>

@property(nonatomic , readwrite , strong)id<UIViewControllerContextTransitioning>transitionContext;

/// 导航栏是否隐藏
@property (nonatomic , readwrite , assign) BOOL navigationBarDidHidden;

/// tabBar是否隐藏
@property (nonatomic , readwrite , assign) BOOL tabBarDidHidden;
@end

@implementation CMHPingInvertTransition



- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.75f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    /// 转场上下文
    self.transitionContext = transitionContext;
    
    /// 源VC
    CMHExample04ViewController *fromVC = (CMHExample04ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    /// 目标VC
    CMHMainFrameViewController *toVC = (CMHMainFrameViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /// 转场View
    UIView *containerView = [transitionContext containerView];
    
    /// 记录一下 导航栏 和 tabBar 的显示状态
    self.navigationBarDidHidden = fromVC.navigationController.navigationBar.hidden;
    self.tabBarDidHidden = fromVC.tabBarController.tabBar.hidden;
    
    fromVC.navigationController.navigationBar.hidden = YES;
    fromVC.tabBarController.tabBar.hidden = YES;
    
    /// 添加View
    [fromVC.view addSubview:fromVC.snapshot];
    [containerView addSubview:toVC.snapshot];
    [containerView bringSubviewToFront:fromVC.view];
    
    CGPoint finalPoint;
    
    /// 获取到CustomView
    UIView *customView = toVC.navigationItem.leftBarButtonItem.customView;
    /// customView在导航栏上 将customView 转换成Window上的坐标系
    CGRect rect = [customView.superview convertRect:customView.frame toView:nil];
    CGPoint center = CGRectGetCenter(rect);
    
    /// 判断触发点在那个象限
    /// 虽然我们知道，customView在第一象限，但是有必要写出具体的逻辑
    if(rect.origin.x > (toVC.view.bounds.size.width * .5)){
        if (rect.origin.y < (toVC.view.bounds.size.height * .5)) {
            // 第一象限
            finalPoint = CGPointMake(center.x - 0, center.y - CGRectGetMaxY(toVC.view.bounds));
        }else{
            // 第四象限
            finalPoint = CGPointMake(center.x - 0, center.y - 0);
        }
    }else{
        if (rect.origin.y < (toVC.view.bounds.size.height / 2)) {
            // 第二象限
            finalPoint = CGPointMake(center.x - CGRectGetMaxX(toVC.view.bounds), center.y - CGRectGetMaxY(toVC.view.bounds));
        }else{
            //第三象限
            finalPoint = CGPointMake(center.x - CGRectGetMaxX(toVC.view.bounds), center.y - 0);
        }
    }
    
    
    
    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    /// 路径动画
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    /// 源VC
    CMHExample04ViewController *fromVC = (CMHExample04ViewController *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    /// 目标VC
    CMHMainFrameViewController *toVC = (CMHMainFrameViewController *)[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.tabBarController.tabBar.hidden = self.tabBarDidHidden;
    toVC.navigationController.navigationBar.hidden = self.navigationBarDidHidden;
    
    [fromVC.snapshot removeFromSuperview];
    [toVC.snapshot removeFromSuperview];
    
    
    /// 过渡完成，添加View
    [[self.transitionContext containerView] addSubview:toVC.view];
    
    
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
    /// 告诉系统此次过渡是否结束
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    
}

@end
