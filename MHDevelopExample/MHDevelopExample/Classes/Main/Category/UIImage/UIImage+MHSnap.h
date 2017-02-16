//
//  UIImage+MHSnap.h
//  JiuluTV
//
//  Created by CoderMikeHe on 16/10/20.
//  Copyright © 2016年 9lmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MHSnap)
/**
 *  屏幕截图
 */
+ (instancetype) mh_captureScreen:(UIView *)view;

@end
