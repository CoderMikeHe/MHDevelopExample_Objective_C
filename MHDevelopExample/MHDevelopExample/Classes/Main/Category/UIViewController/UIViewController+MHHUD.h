//
//  UIViewController+MHHUD.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来  显示MBProgressHUD的 ....
 */

#import <UIKit/UIKit.h>

@interface UIViewController (MHHUD)
/**
 *  在某个view上显示HUD
 *
 *  @param view 显示在某个view上
 *  @param hint 显示内容
 */
- (void)mh_showHudInView:(UIView *)view hint:(NSString *)hint;
/**
 *  隐藏掉HUD
 */
- (void)mh_hideHud;
/**
 *  在window上显示HUD
 *  显示在底部
 *  @param hint 显示内容
 */
- (void)mh_showHint:(NSString *)hint;
/**
 *  在window上显示HUD
 *  显示在顶部
 *  @param hint 显示内容
 */
- (void)mh_showTopHint:(NSString *)hint;
/**
 *  在window上显示HUD
 *  显示在底部
 *  @param hint 显示内容
 */
- (void)mh_showBottomHint:(NSString *)hint;


/**
 *  从show 哪个View的中心点显示的位置再往(上-) (下+)yOffset
 *
 *  @param hint    显示内容
 *  @param yOffset 偏移量  - 中心点上移   + 中心点下移
 */
- (void)mh_showHint:(NSString *)hint yOffset:(float)yOffset;
@end
