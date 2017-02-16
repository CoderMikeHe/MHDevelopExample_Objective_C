//
//  UIImage+MHOrientation.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 处理图片旋转的...
 */
#import <UIKit/UIKit.h>

@interface UIImage (MHOrientation)
/**
 *  将图片旋转到指定的方向
 *
 *  @param sourceImage 要旋转的图片
 *  @param orientation 旋转方向
 *
 *  @return 返回旋转后的图片
 */
+ (UIImage *) mh_fixImageOrientationWithSourceImage:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation;

/***
 *  将图片旋转到指定方向
 */
+ (UIImage *)mh_fixOrientation:(UIImage *)aImage;
@end
