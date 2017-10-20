//
//  SUWebViewController0.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUWebViewController0.h"
/// KVO 监听的属性
/// 加载情况
static NSString * const SUWebViewKVOLoading = @"loading";
/// 文章标题
static NSString * const SUWebViewKVOTitle = @"title";
/// 进度
static NSString * const SUWebViewKVOEstimatedProgress = @"estimatedProgress";

@interface SUWebViewController0 ()
/// webView
@property (nonatomic, weak, readwrite) WKWebView *webView;
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;

@property (nonatomic, readwrite, strong) UIBarButtonItem *closeItem;
@end

@implementation SUWebViewController0
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}
- (void)dealloc
{
    MHDealloc;
    /// remove observer ,otherwise will crash
    [_webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *url;
    if ([self.request isKindOfClass:[NSURL class]]) {
        url = (NSURL *)self.request;
    } else {
        url = [NSURL URLWithString:self.request];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *userAgent = @"CoderMIkeHe_iOS";
    
    if (!(MHIOSVersion>=9.0)) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgent}];
    }
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    /// 这里可以注册JS的处理 涉及公司私有方法 这里笔者不作处理
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:MHMainScreenBounds configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    if ((MHIOSVersion>=9.0)) webView.customUserAgent = userAgent;
    self.webView = webView;
    [self.view addSubview:webView];
    
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"navigator.userAgent-----%@", result);
    }];
    
    /// 监听数据
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    /// binding self.viewModel.avatarUrlString
    [_KVOController mh_observe:self.webView keyPath:SUWebViewKVOTitle block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        self.title = self.webView.title;
    }];
    [_KVOController mh_observe:self.webView keyPath:SUWebViewKVOLoading block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"--- webView is loading ---");
    }];
    
    [_KVOController mh_observe:self.webView keyPath:SUWebViewKVOEstimatedProgress block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }];
    
}

#pragma mark - 事件处理
- (void)_closeItemDidiClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    /// js call OC function
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
    if (backItem) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[backItem, self.closeItem]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[backItem]];
        }
    }
}

#pragma mark - Getter & Setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = SCREEN_WIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        // iOS7 Safari bar color :[UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]
        progressView.progressTintColor = SUGlobalPinkColor;
        progressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(_closeItemDidiClicked)];
    }
    return _closeItem;
}

@end
