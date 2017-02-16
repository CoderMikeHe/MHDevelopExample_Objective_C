//
//  UIImage+MHSnap.m
//  JiuluTV
//
//  Created by CoderMikeHe on 16/10/20.
//  Copyright © 2016年 9lmedia. All rights reserved.
//

#import "UIImage+MHSnap.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImage (MHSnap)

/**
 *  屏幕截图
 */
+ (instancetype) mh_captureScreen:(UIView *)view
{
    // 手动开启图片上下文
    UIGraphicsBeginImageContext(view.bounds.size);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染上下文到图层
    [view.layer renderInContext:ctx];
    
    // 从当前上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
