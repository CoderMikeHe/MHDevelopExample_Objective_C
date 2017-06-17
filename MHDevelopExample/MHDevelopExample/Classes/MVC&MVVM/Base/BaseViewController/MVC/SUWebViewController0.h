//
//  SUWebViewController0.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVC 中加载WebView的最基础的控制器 -- C

#import "SUViewController0.h"
#import <WebKit/WebKit.h>
@interface SUWebViewController0 : SUViewController0<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>
/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
/// request
@property (nonatomic, readwrite, copy) NSString *request;

@end
