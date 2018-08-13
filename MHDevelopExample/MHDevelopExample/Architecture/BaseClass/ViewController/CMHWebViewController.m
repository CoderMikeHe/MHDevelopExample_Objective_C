//
//  CMHWebViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/7.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHWebViewController.h"
#import "FBKVOController+MHExtension.h"
#import "UIScrollView+MHRefresh.h"


/// KVO 监听的属性
/// 加载情况
static NSString * const CMHWebViewKVOLoading = @"loading";
/// 文章标题
static NSString * const CMHWebViewKVOTitle = @"title";
/// 进度
static NSString * const CMHWebViewKVOEstimatedProgress = @"estimatedProgress";


/// CoderMikeHe Fixed Bug : 防止循环引用，以及重复添加handler
/// https://www.jianshu.com/p/3cc26c48b7e7
/// https://www.jianshu.com/p/6ba2507445e4
/// http://blog.cocosdever.com/2016/03/07/WKWebView-JS%E4%BA%92%E4%BA%A4%E5%BC%80%E5%8F%91%E4%B8%8E%E5%86%85%E5%AD%98%E6%B3%84%E6%BC%8F/

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

- (void)dealloc{
    MHDealloc;
}

@end


@interface CMHWebViewController ()<UIScrollViewDelegate>
/// webView
@property (nonatomic, weak, readwrite) WKWebView *webView;
/// 进度条
@property (nonatomic, readwrite, strong) UIProgressView *progressView;
/// 返回按钮
@property (nonatomic, readwrite, strong) UIBarButtonItem *backItem;
/// 关闭按钮 （点击关闭按钮  退出WebView）
@property (nonatomic, readwrite, strong) UIBarButtonItem *closeItem;

@end

@implementation CMHWebViewController
{
    /// KVOController 监听数据
    FBKVOController *_KVOController;
}


- (void)dealloc{
    MHDealloc;
    /// remove observer ,otherwise will crash
    [_webView stopLoading];
    /// CoderMikeHe Fixed Bug :移除掉JS调用OC的方法，否则循环引用
    for (NSString * name in _messageHandlers) {
        [_webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
    
    [_webView stopLoading];
    _webView.scrollView.delegate = nil;
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    _webView = nil;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _shouldBeginRefreshing = YES;
        _navigationBarHeight = MH_APPLICATION_TOP_BAR_HEIGHT;
        /// 关掉IQKeyboard，以免与H5中控制键盘的逻辑冲突
        self.keyboardEnable = NO;
    }
    return self;
}

- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [super initWithParams:params]) {
        self.requestUrl = params[CMHViewControllerRequestUrlKey];
        _shouldBeginRefreshing = YES;
        _navigationBarHeight = MH_APPLICATION_TOP_BAR_HEIGHT;
        /// 关掉IQKeyboard，以免与H5中控制键盘的逻辑冲突
        self.keyboardEnable = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置
    [self _cmh_setup];
    
    /// 设置导航栏
    [self _cmh_setupNavigationItem];
    
    /// 设置子控件
    [self _cmh_setupSubViews];
    
    /// 布局子空间
    [self _cmh_makeSubViewsConstraints];
    
}

#pragma mark - 事件处理
- (void)_backItemDidClicked{ /// 返回按钮事件处理
    /// 可以返回到上一个网页，就返回到上一个网页
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{/// 不能返回上一个网页，就返回到上一个界面
        /// 判断 是Push还是Present进来的，
        [self _closeItemDidClicked];
    }
}

- (void)_closeItemDidClicked{
    /// 判断 是Push还是Present进来的
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 9.0以下将文件夹copy到tmp目录
- (NSURL *)_fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *temDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    return dstURL;
}


#pragma mark - Override
- (void)configure{
    [super configure];
    
    /// 容错处理
    if (MHStringIsNotEmpty(self.requestUrl) && !self.isLocalFile)  {    /// 网络
        //格式化含有中文的url
        self.requestUrl =  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self.requestUrl, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", nil, kCFStringEncodingUTF8));
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
        /// 加载请求数据
        [self.webView loadRequest:request];
    }else if (MHStringIsNotEmpty(self.requestUrl) && self.isLocalFile){ /// 本地
        /// 本地分 ios9.0以下 和 ios9.0以上处理方式
        /// https://www.jianshu.com/p/ccb421c85b2e
        /// https://blog.csdn.net/xinshou_caizhu/article/details/72614584
        /// https://blog.csdn.net/wojiaoqiaoxiaoqiao/article/details/79876904
        NSURL *fileURL = [NSURL fileURLWithPath:self.requestUrl];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            // iOS8. Things can be workaround-ed
            //   Brave people can do just this
            fileURL = [self _fileURLForBuggyWKWebView8:fileURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self.webView loadRequest:request];
        }
    }

    /// 注册 JS调用OC的方法
    for (NSString * name in self.messageHandlers) {
        [self.webView.configuration.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:name];
    }
}


- (UIEdgeInsets)contentInset{
    return UIEdgeInsetsMake(MH_APPLICATION_TOP_BAR_HEIGHT, 0, 0, 0);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /// js call OC function
    NSLog(@"------>>> JS--Call--OC <<<------\n message.name:  %@\n message.body:  %@",message.name, message.body);
}

#pragma mark - WKNavigationDelegate
/// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    /// 不显示关闭按钮
    if(self.shouldDisableWebViewClose) return;
    
    UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItems.firstObject;
    if (backItem) {
        if ([self.webView canGoBack]) {
            [self.navigationItem setLeftBarButtonItems:@[backItem, self.closeItem]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[backItem]];
        }
    }
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.shouldPullDownToRefresh) [webView.scrollView.mj_header endRefreshing];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"navigationAction.request.URL:   %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    /// CoderMike Fixed : 解决点击网页的链接 不跳转的Bug。
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark runJavaScript
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [NSObject mh_showAlertViewWithTitle:nil message:message confirmTitle:@"我知道了"];
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    completionHandler(defaultText);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /// CoderMikeHe Fixed Bug ： 调整webView滚动速率
    /// https://www.cnblogs.com/NSong/p/6489802.html
    /// https://github.com/ShingoFukuyama/WKWebViewTips
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    MHLogFunc;
//    /// 不要有缩放手势
//    /// https://www.jianshu.com/p/c3003ebc4e48
//    /// https://blog.csdn.net/flting1017/article/details/76985126/
//    return nil;
//}


#pragma mark - 初始化
- (void)_cmh_setup{
}

#pragma mark - 设置导航栏
- (void)_cmh_setupNavigationItem{
    self.navigationItem.leftBarButtonItem = self.backItem;
}
#pragma mark - 设置子控件
- (void)_cmh_setupSubViews{
    
    /// CoderMikeHe FIXED: 切记 lightempty_ios 是前端跟H5商量的结果，请勿修改。
    NSString *userAgent = @"wechat_ios";
    
    /// 注册JS
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    /// 赋值userContentController
    configuration.userContentController = userContentController;
    
    // CoderMikeHe Fixed : 自适应屏幕宽度js
    NSString *jsString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    [userContentController addUserScript:userScript];
    
    /// 字体
    configuration.preferences.minimumFontSize = 10;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    /// 把手动播放设置NO ios(8.0, 9.0)
    if (MH_iOS9_VERSTION_LATER) {
        /// 9.0以后的版本
        // 允许视频播放
        configuration.allowsAirPlayForMediaPlayback = YES;
        configuration.requiresUserActionForMediaPlayback = YES;
        if (MH_iOS10_VERSTION_LATER) {
            /// 10.0以后的版本
            configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        }
    }else{
        /// 9.0之前的版本
        configuration.mediaPlaybackRequiresUserAction = YES;
        configuration.mediaPlaybackAllowsAirPlay = YES;
        
    }
    // 是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
    configuration.allowsInlineMediaPlayback = YES;
    
    // 允许可以与网页交互，选择视图
    configuration.selectionGranularity = WKSelectionGranularityDynamic;
    // web内容处理池
    configuration.processPool = [[WKProcessPool alloc] init];
    // 是否等待内容全部加到内存中再去渲染webView
    configuration.suppressesIncrementalRendering = NO;
    
    /// 初始化WebView
    WKWebView *webView = [[WKWebView alloc] initWithFrame:MH_SCREEN_BOUNDS configuration:configuration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    /// 设置代理
    webView.scrollView.delegate = self;
    
    // 设置请求的User-Agent信息中应用程序名称 iOS9后可用 以下方法二选一
    if ((MHIOSVersion >= 9.0)) webView.customUserAgent = userAgent;
//    if ((MHIOSVersion >= 9.0)) configuration.applicationNameForUserAgent = userAgent;
    
    self.webView = webView;
    [self.view addSubview:webView];
    
    /// oc调用js
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSLog(@"navigator.userAgent.result is ++++ %@", result);
    }];
    
    /// 监听数据
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    /// binding self.avatarUrlString
    [_KVOController mh_observe:self.webView keyPath:CMHWebViewKVOTitle block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        /// CoderMikeHe FIXED: 这里只设置导航栏的title 以免self.title 设置了tabBarItem.title
        if (!self.shouldDisableWebViewTitle) self.navigationItem.title = self.webView.title;
    }];
    [_KVOController mh_observe:self.webView keyPath:CMHWebViewKVOLoading block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        NSLog(@"--- webView is loading ---");
    }];
    
    [_KVOController mh_observe:self.webView keyPath:CMHWebViewKVOEstimatedProgress block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
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
    
    /// 添加下拉刷新控件
    if(self.shouldPullDownToRefresh){
        [self.webView.scrollView cmh_addHeaderRefresh:^(MJRefreshHeader *header) {
            @strongify(self);
            [self.webView reload];
        }];
        if (self.shouldBeginRefreshing) {
            [self.webView.scrollView.mj_header beginRefreshing];
        }
    }
    self.webView.scrollView.contentInset = self.contentInset;
    
    
#ifdef __IPHONE_11_0
    /// CoderMikeHe: 适配 iPhone X + iOS 11，去掉安全区域
    if (@available(iOS 11.0, *)) {
        MHAdjustsScrollViewInsets_Never(webView.scrollView);
    }
#endif
    /// CoderMikeHe Fixed Bug ： 将进度条加载在当前控制器上面
    [self.view addSubview:self.progressView];
    
}
#pragma mark - 布局子控件
- (void)_cmh_makeSubViewsConstraints{
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(3);
        make.top.equalTo(self.view).with.offset(self.navigationBarHeight);
    }];
}

#pragma mark - Getter & Setter
- (UIProgressView *)progressView {
    if (!_progressView) {
        CGFloat progressViewW = MH_SCREEN_WIDTH;
        CGFloat progressViewH = 3;
        CGFloat progressViewX = 0;
        CGFloat progressViewY = CGRectGetHeight(self.navigationController.navigationBar.frame) - progressViewH + 1;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        progressView.progressTintColor = CMH_MAIN_TINTCOLOR;
        progressView.trackTintColor = [UIColor clearColor];
        progressView.progress = 0;
        self.progressView = progressView;
    }
    return _progressView;
}


- (UIBarButtonItem *)backItem{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem mh_backItemWithTitle:@"返回" imageName:@"barbuttonicon_back_15x30" target:self action:@selector(_backItemDidClicked)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [UIBarButtonItem mh_systemItemWithTitle:@"关闭" titleColor:nil imageName:nil target:self selector:@selector(_closeItemDidClicked) textType:YES];
    }
    return _closeItem;
}

- (void)setShouldPullDownToRefresh:(BOOL)shouldPullDownToRefresh{
    if (_shouldPullDownToRefresh != shouldPullDownToRefresh) {
        _shouldPullDownToRefresh = shouldPullDownToRefresh;
        if (_shouldPullDownToRefresh) {
            @weakify(self);
            [self.webView.scrollView cmh_addHeaderRefresh:^(MJRefreshHeader *header) {
                /// 加载下拉刷新的数据
                @strongify(self);
                [self.webView reload];
            }];
        }else{
            self.webView.scrollView.mj_header = nil;
        }
    }
}

@end

