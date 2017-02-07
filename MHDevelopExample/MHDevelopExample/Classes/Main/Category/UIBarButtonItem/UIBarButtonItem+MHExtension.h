//
//  UIBarButtonItem+MHExtension.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 快速创建一个UIBarButtonItem....
 */
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (MHExtension)
/**
 *  快速创建一个 UIBarButtonItem
 *
 *  @param imageName     普通状态下的图片
 *  @param highImageName 高亮状态下的图片
 *  @param target        目标
 *  @param action        操作
 *
 */
+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
@end
