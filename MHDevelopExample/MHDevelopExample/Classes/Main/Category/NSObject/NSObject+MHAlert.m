//
//  NSObject+MHAlert.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/8/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "NSObject+MHAlert.h"
#import "CMHControllerHelper.h"

@implementation NSObject (MHAlert)

+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle {
    
    [self mh_showAlertViewWithTitle:title message:message confirmTitle:confirmTitle confirmAction:NULL];
}

+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmAction:(void(^)())confirmAction {
    
    [self mh_showAlertViewWithTitle:title message:message confirmTitle:confirmTitle cancelTitle:nil confirmAction:confirmAction cancelAction:NULL];
}

+ (void)mh_showAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirmAction:(void(^)(void))confirmAction cancelAction:(void(^)(void))cancelAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    /// 配置alertController
    alertController.titleColor = MHColorFromHexString(@"#333333");
    alertController.messageColor = MHColorFromHexString(@"#333333");
    
    /// 左边按钮
    if(cancelTitle.length>0){
        UIAlertAction *cancel= [UIAlertAction actionWithTitle:cancelTitle?cancelTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { !cancelAction?:cancelAction(); }];
        cancel.textColor = MHColorFromHexString(@"#8E929D");
        [alertController addAction:cancel];
    }
    
    
    if (confirmTitle.length>0) {
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:confirmTitle?confirmTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { !confirmAction?:confirmAction();}];
        confirm.textColor = CMH_MAIN_TINTCOLOR;
        [alertController addAction:confirm];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CMHControllerHelper currentViewController] presentViewController:alertController animated:YES completion:NULL];
    });
}

@end
