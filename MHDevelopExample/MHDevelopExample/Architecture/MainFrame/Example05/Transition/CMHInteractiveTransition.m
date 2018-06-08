//
//  CMHInteractiveTransition.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHInteractiveTransition.h"

@interface CMHInteractiveTransition ()
/// 是否允许完成
@property (nonatomic , readwrite, assign) BOOL shouldComplete;
/// 正在弹出的VC
@property (nonatomic , readwrite, strong) UIViewController *presentingViewController;

@end


@implementation CMHInteractiveTransition

#pragma mark - Override
-(CGFloat)completionSpeed{
    return 1 - self.percentComplete;
}

#pragma mark - Public Method
- (void)wireToViewController:(UIViewController *)viewController{
    /// 记录
    self.presentingViewController = viewController;
    
    /// 准备侧滑手势
    [self _prepareGestureRecognizerInView:viewController.view];
}

#pragma mark - Private Method
- (void)_prepareGestureRecognizerInView:(UIView*)view {
    /// 屏幕左边侧滑
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleGesture:)];
    //设置从什么边界滑入
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePanGestureRecognizer];
}


#pragma mark - User Action
- (void)_handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 计算手指滑的物理距离（滑了多远，与起始位置无关）
    CGFloat progress = [gestureRecognizer translationInView:gestureRecognizer.view.superview].x /(gestureRecognizer.view.superview.bounds.size.width);
    
    // 把这个百分比限制在0~1之间
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // 1. Mark the interacting flag. Used when supplying it in delegate.
            self.interacting = YES;
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged: {
            // 2. 当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // 3. Gesture over. Check if the transition should happen or not
            self.interacting = NO;
            // 当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
            /// 手势结束时如果进度大于.5，那么就完成pop操作，否则重新来过。
            if (progress > .5f) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}


@end
