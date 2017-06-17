//
//  SUWebViewController1.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的所有自定义的含有 web视图（WKWebView）控制器的父类

#import "SUViewController1.h"
#import <WebKit/WebKit.h>
#import "SUWebViewModel1.h"
@interface SUWebViewController1 : SUViewController1<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>
/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
@end
