//
//
//  MBProgressHUD+MH.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MH)

/**
 * 提交正确的success提示  背景无蒙版
 */
+ (void)mh_showSuccess:(NSString *)success addedToView:(UIView *)view;
/**
 * 提交失败的failure提示  背景无蒙版
 */
+ (void)mh_showError:(NSString *)error addedToView:(UIView *)view;

// 提示成功 show In window
+ (void)mh_showSuccess:(NSString *)success;
// 提示失败 show In window
+ (void)mh_showError:(NSString *)error;



/**
 * 这个方法 带一层蒙版  view 传nil 显示在window上
 */
+ (MBProgressHUD *)mh_showMessage:(NSString *)message addedToView:(UIView *)view;
/**
 * 这个方法 带一层蒙版  显示在window上
 */
+ (MBProgressHUD *)mh_showMessage:(NSString *)message;


/**
 * 隐藏 HUD
 */
+ (void)mh_hideHUDForView:(UIView *)view;
+ (void)mh_hideHUD;


// 显示在上方
+ (void)mh_showHint:(NSString *)hint;
// 显示在上方
+ (void)mh_showTopHint:(NSString *)hint;
// 显示在下方
+ (void)mh_showBottomHint:(NSString *)hint;

// 从默认(mh_showHint:)显示的位置再往上(下)yOffset
+ (void)mh_showHint:(NSString *)hint yOffset:(float)yOffset;

@end
