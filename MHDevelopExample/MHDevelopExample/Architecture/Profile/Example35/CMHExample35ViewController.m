//
//  CMHExample35ViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/8/10.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample35ViewController.h"

/// JS 调用 原生 的方法

/// 扫一扫
static NSString * const CMHJSCallNative_ScanAction = @"ScanAction";
/// 获取定位
static NSString * const CMHJSCallNative_Location = @"Location";
/// 分享
static NSString * const CMHJSCallNative_Share = @"Share";
/// 修改背景色
static NSString * const CMHJSCallNative_Color = @"Color";
/// 支付
static NSString * const CMHJSCallNative_Pay = @"Pay";
/// 返回
static NSString * const CMHJSCallNative_GoBack = @"GoBack";
/// 摇一摇
static NSString * const CMHJSCallNative_Shake = @"Shake";
/// 播放声音
static NSString * const CMHJSCallNative_PlaySound = @"PlaySound";


@interface CMHExample35ViewController ()

@end

@implementation CMHExample35ViewController

/// 重写init方法，配置你想要的属性
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 配置js调用oc的方法名
        self.messageHandlers = @[CMHJSCallNative_ScanAction , CMHJSCallNative_Location , CMHJSCallNative_Share , CMHJSCallNative_Color , CMHJSCallNative_Pay , CMHJSCallNative_Shake , CMHJSCallNative_GoBack , CMHJSCallNative_PlaySound];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JS交互";
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
    NSLog(@"------>>> JS--Call--OC <<<------\n message.name:  %@\n message.body:  %@",message.name, message.body);
    
    /// 以下就是JS 调用 OC 的事件监听 ， 请结合自身实际情况去处理其事件的处理
    NSString *title = nil;
    NSString *subtitle = @"监听JS调用OC事件，具体逻辑还请按照实际情况去处理";
    if ([message.name isEqualToString:CMHJSCallNative_ScanAction]) {
        /// 扫一扫
        title = @"扫一扫";
    }else if ([message.name isEqualToString:CMHJSCallNative_Location]) {
        /// 获取位置
        title = @"获取定位";
    }else if ([message.name isEqualToString:CMHJSCallNative_Share]) {
        /// 分享
        title = @"分享";
    }else if ([message.name isEqualToString:CMHJSCallNative_Color]) {
        /// 修改背景色
        title = @"修改背景色";
    }else if ([message.name isEqualToString:CMHJSCallNative_Pay]) {
        /// 支付
        title = @"支付";
    }else if ([message.name isEqualToString:CMHJSCallNative_GoBack]) {
        /// 返回
        title = @"返回";
    }else if ([message.name isEqualToString:CMHJSCallNative_Shake]) {
        /// 摇一摇
        title = @"摇一摇";
    }else if ([message.name isEqualToString:CMHJSCallNative_PlaySound]) {
        /// 播放声音
        title = @"播放声音";
    }
    
    [NSObject mh_showAlertViewWithTitle:title message:subtitle confirmTitle:@"我知道了"];
}

@end
