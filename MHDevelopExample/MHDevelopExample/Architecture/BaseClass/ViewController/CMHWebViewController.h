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

/// web url quest 如果localFile == YES , 则requestUrl 为本地路径 ； 反之，requestUrl为远程url str
@property (nonatomic, readwrite, copy) NSString *requestUrl;
/// 是否是本地文件 default is NO
@property (nonatomic , readwrite , assign , getter = isLocalFile) BOOL localFile;

/// 下拉刷新 defalut is NO
@property (nonatomic, readwrite, assign) BOOL shouldPullDownToRefresh;
/// 是否默认开启自动刷新， YES : 系统会自动调用下拉刷新事件。  NO : 开发人员手动调用需要手动拖拽 默认是YES
@property (nonatomic, readwrite, assign) BOOL shouldBeginRefreshing;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;

/// 是否取消关闭按钮。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewClose;

/// messageHandlers: 就是你要注册的 JS 调用 OC 的方法名
@property (nonatomic , readwrite , copy) NSArray <NSString *> *messageHandlers;
/// 导航栏高度 默认是 系统导航栏的高度
@property (nonatomic , readwrite , assign) CGFloat navigationBarHeight;

@end
