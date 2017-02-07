//
//  UIView+MHExtension.m
//  MHDevLibExample
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIView+MHExtension.h"

@implementation UIView (MHExtension)
/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)mh_isShowingOnKeyWindow
{
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

/**
 * xib创建的view
 */
+ (instancetype)mh_viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
@end
