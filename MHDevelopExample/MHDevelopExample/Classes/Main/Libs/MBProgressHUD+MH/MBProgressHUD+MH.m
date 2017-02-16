//
//
//  MBProgressHUD+MH.m
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MBProgressHUD+MH.h"
//导航栏高度
static CGFloat const MHNavigationBarHeight = 64;
//tabBar高度
static CGFloat const MHTabBarHeight = 49;

@implementation MBProgressHUD (MH)
#pragma mark 显示信息
+ (void)mh_show:(NSString *)text icon:(NSString *)icon addedToView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].delegate window];
        if (!view) {
            view = [[[UIApplication sharedApplication] windows] lastObject];
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = MHMediumFont(14.0f);
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // 改变hud 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    // HUD 显示框
    hud.bezelView.color = [UIColor blackColor];
    // HUD透明度
    hud.bezelView.alpha = 0.95;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0f];
}

#pragma mark 显示错误信息
+ (void)mh_showError:(NSString *)error addedToView:(UIView *)view
{
    [self mh_show:error icon:@"error" addedToView:view];
}

+ (void)mh_showSuccess:(NSString *)success addedToView:(UIView *)view
{
    [self mh_show:success icon:@"success" addedToView:view];
}


+ (void)mh_showSuccess:(NSString *)success
{
    [self mh_showSuccess:success addedToView:nil];
}
+ (void)mh_showError:(NSString *)error
{
    [self mh_showError:error addedToView:nil];
}



+ (MBProgressHUD *)mh_showMessage:(NSString *)message
{
    return [self mh_showMessage:message addedToView:nil];
}
+ (MBProgressHUD *)mh_showMessage:(NSString *)message addedToView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].delegate window];
        if (!view) {
            view = [[[UIApplication sharedApplication] windows] lastObject];
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    hud.label.font = MHMediumFont(14.0f);
    // 改变hud 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    // HUD 显示框
    hud.bezelView.color = [UIColor blackColor];
    // HUD透明度
    hud.bezelView.alpha = 0.95;
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    return hud;
}


// 隐藏HUD
+ (void)mh_hideHUDForView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].delegate window];
        if (!view) {
            view = [[[UIApplication sharedApplication] windows] lastObject];
        }
    }
    [self hideHUDForView:view animated:YES];
}
+ (void)mh_hideHUD
{
    [self mh_hideHUDForView:nil];
}






//MKH  这个默认显示上方
+ (void)mh_showHint:(NSString *)hint
{
    [self mh_showBottomHint:hint];
}

// 显示在上方
+ (void)mh_showTopHint:(NSString *)hint
{
    // 显示提示信息
    [self mh_showHint:hint yOffset:-([UIScreen mainScreen].bounds.size.height*0.5-MHNavigationBarHeight-MHNavigationBarHeight*0.2)];
}
//显示在下方
+ (void)mh_showBottomHint:(NSString *)hint
{
    [self mh_showHint:hint yOffset:(([UIScreen mainScreen].bounds.size.height*0.5-MHTabBarHeight-MHNavigationBarHeight*0.5))];
}

// 从默认(mh_showHint:)显示的位置再往上(下)yOffset
+ (void)mh_showHint:(NSString *)hint yOffset:(float)yOffset
{
    [self mh_hideHUD];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = hint;
    hud.label.font = MHMediumFont(14.0f);
    hud.margin = 10.f;
    // 改变hud 内容的颜色
    hud.contentColor = [UIColor whiteColor];
    // HUD 显示框
    hud.bezelView.color = [UIColor blackColor];
    // HUD透明度
    hud.bezelView.alpha = 0.95;
    
    // 偏移量
    CGPoint offset = CGPointMake(hud.offset.x, yOffset);
    hud.offset = offset;
    // 两秒后移除删除
    [hud hideAnimated:YES afterDelay:2.0f];
}
@end
