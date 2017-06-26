//
//  SUWebViewController2.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的所有自定义的含有 web视图（WKWebView）控制器的父类

#import "SUViewController2.h"
#import <WebKit/WebKit.h>
#import "SUWebViewModel2.h"
@interface SUWebViewController2 : SUViewController2<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>
/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
@end
