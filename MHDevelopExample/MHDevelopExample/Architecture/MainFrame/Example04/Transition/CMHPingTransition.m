//
//  CMHPingTransition.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHPingTransition.h"
#import "CMHMainFrameViewController.h"
#import "CMHExample04ViewController.h"
@interface CMHPingTransition ()<CAAnimationDelegate>

@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;

/// 导航栏是否隐藏
@property (nonatomic , readwrite , assign) BOOL navigationBarDidHidden;

/// tabBar是否隐藏
@property (nonatomic , readwrite , assign) BOOL tabBarDidHidden;
@end

@implementation CMHPingTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  .75f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    /// 记录过渡上下文
    self.transitionContext = transitionContext;
    
    /// 获取来源控制器
    CMHMainFrameViewController * fromVC = (CMHMainFrameViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    /// 获取目的控制器
    CMHExample04ViewController *toVC = (CMHExample04ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /// 获取容器 动画就发生在这个View上
    UIView *containerView = [transitionContext containerView];
    
    /// 记录一下 导航栏 和 tabBar 的显示状态
    self.navigationBarDidHidden = fromVC.navigationController.navigationBar.hidden;
    self.tabBarDidHidden = fromVC.tabBarController.tabBar.hidden;
    
    /// 隐藏fromVC上的导航栏，避免动画发生在其导航栏底部，用户体验不好
    fromVC.navigationController.navigationBar.hidden = YES;
    /// 隐藏fromVC上的tabBar，避免动画过程中，tabBar移动到屏幕的最左侧的动画，用户体验不好
    fromVC.tabBarController.tabBar.hidden = YES;
    
    
    
    /// Tips：添加fromVC的缩略图，让用户产生以为动画是发生在 fromVC 之上的错觉。但其实这只是一个缩略图罢了
    /// 隐藏fromVc.view,别让用户看出
    fromVC.view.hidden = YES;
    [containerView addSubview:fromVC.snapshot];
    /// 添加到容器上
    [containerView addSubview:toVC.view];
    
    // 创建两个圆形的 UIBezierPath 实例；一个是 customView 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    CGPoint finalPoint;
    
    /// 获取到CustomView
    UIView *customView = fromVC.navigationItem.leftBarButtonItem.customView;
    
    /// customView在导航栏上 将customView 转换成Window上的坐标系
    CGRect rect = [customView.superview convertRect:customView.frame toView:nil];
    CGPoint center = CGRectGetCenter(rect);
    /// 判断触发点在那个象限
    /// 虽然我们知道，customView在一定在第一象限，但是有必要写出具体各个情况的的逻辑
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
    
    /// 计算出半径
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    
    /// 开始蒙版
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:rect];
    /// 结束蒙版
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, -radius, -radius)];

    // 创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    // 将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    maskLayer.path = maskFinalBP.CGPath;
    /// 设置遮罩
    toVC.view.layer.mask = maskLayer;
    
    /// 开启一个基础动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}


#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    // 告诉 系统 这个 transition 完成
    [self.transitionContext completeTransition:![self. transitionContext transitionWasCancelled]];
    
    /// 获取来源控制器
    CMHMainFrameViewController *fromVC = (CMHMainFrameViewController *)[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    /// 动画结束，fromVC 回到之前状态
    fromVC.view.hidden = NO;
    [fromVC.snapshot removeFromSuperview];
    fromVC.navigationController.navigationBar.hidden = self.navigationBarDidHidden;
    fromVC.tabBarController.tabBar.hidden = self.tabBarDidHidden;
    
    
    // 清除 fromVC 的 mask
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    /// 清除 toVC 的mask
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}



@end
