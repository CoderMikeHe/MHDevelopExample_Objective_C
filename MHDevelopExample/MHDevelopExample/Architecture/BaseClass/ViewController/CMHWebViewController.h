//
//  CMHWebViewController.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/7.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHViewController.h"
#import <WebKit/WebKit.h>
@interface CMHWebViewController : CMHViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
/// webView
@property (nonatomic, weak, readonly) WKWebView *webView;
/// 内容缩进 (64,0,0,0)
@property (nonatomic, readonly, assign) UIEdgeInsets contentInset;

/// web url quest
@property (nonatomic, readwrite, copy) NSURLRequest *request;

/// 下拉刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 是否默认开启自动刷新， YES : 系统会自动调用下拉刷新事件。  NO : 开发人员手动调用需要手动拖拽 默认是YES
@property (nonatomic, readwrite, assign) BOOL shouldBeginRefreshing;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;

/// 是否取消关闭按钮。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewClose;

@end
