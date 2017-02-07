//
//  UIView+MHFrame.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来  快速获得或者添加 控件的尺寸 ....
 */

#import <UIKit/UIKit.h>

@interface UIView (MHFrame)
/**
 *  控件x值
 */
@property (nonatomic, assign) CGFloat mh_x;

/**
 *  控件y值
 */
@property (nonatomic, assign) CGFloat mh_y;

/**
 *  控件centerX值
 */
@property (nonatomic, assign) CGFloat mh_centerX;

/**
 *  控件centerY值
 */
@property (nonatomic, assign) CGFloat mh_centerY;

/**
 *  控件width值
 */
@property (nonatomic, assign) CGFloat mh_width;

/**
 *  控件height值
 */
@property (nonatomic, assign) CGFloat mh_height;

/**
 *  控件size值
 */
@property (nonatomic, assign) CGSize mh_size;






@end
