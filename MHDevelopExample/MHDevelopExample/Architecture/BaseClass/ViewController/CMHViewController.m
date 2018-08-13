//
//  CMHViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//


/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
NSString *const CMHViewControllerIDKey = @"CMHViewControllerIDKey";
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
NSString *const CMHViewControllerUtilKey = @"CMHViewControllerUtilKey";
/// 传递webView Request的key：例如 webView request...
NSString *const CMHViewControllerRequestUrlKey = @"CMHViewControllerRequestUrlKey";

#import "CMHNavigationController.h"
#import "CMHViewController.h"

@interface CMHViewController ()
/// The `params` parameter in `-initWithParams:` method.
@property (nonatomic, readwrite, copy) NSDictionary *params;
@end

@implementation CMHViewController

- (void)dealloc{
    /// 销毁时保存数据
    MHDealloc;
}

// when `CMHViewController ` created and call `viewDidLoad` method , execute `requestRemoteData` Or `configure` method
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    CMHViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController configure];
         
         /// 请求数据
         if (viewController.shouldRequestRemoteDataOnViewDidLoad) {
             [viewController requestRemoteData];
         }
     }];
    return viewController;
}


- (instancetype)initWithParams:(NSDictionary *)params{
    /// CoderMikeHe Fixed Bug: 这里调用self init ,便于其他开发人员直接采用 [xxx alloc] init]创建控制器，向下兼容吧
    if (self = [self init]) {
        _params = params;
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        /// 基础配置
        /// 默认在viewDidLoad里面服务器的数据
        _shouldRequestRemoteDataOnViewDidLoad = YES;
        
        /// FDFullscreenPopGesture
        _interactivePopDisabled = NO;
        _prefersNavigationBarHidden = NO;
        
        /// custom
        _prefersNavigationBarBottomLineHidden = NO;
        
        /// 允许IQKeyboardMananger接管键盘弹出事件
        _keyboardEnable = YES;
        _shouldResignOnTouchOutside = YES;
        _keyboardDistanceFromTextField = 10.0f;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /// 隐藏导航栏细线
    CMHNavigationController *nav = (CMHNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[CMHNavigationController class]]) { /// 容错
        /// 显示或隐藏
        self.prefersNavigationBarBottomLineHidden?[nav hideNavigationBottomLine]:[nav showNavigationBottomLine];
    }
    
    /// 配置键盘
    IQKeyboardManager.sharedManager.enable = self.keyboardEnable;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.shouldResignOnTouchOutside;
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.keyboardDistanceFromTextField;
    
    if (nav) {
        /**
         原因：
         viewController.navigationItem.backBarButtonItem = nil;
         [viewController.navigationItem setHidesBackButton:YES];
         CoderMikeHe: Fixed Bug 上面这个方法，会导致侧滑取消时，导航栏出现三个蓝点，系统层面的BUg
         这种方法也不是最完美的，第一次侧滑取消 也会复现
         */
        for (UIView *subView in nav.navigationBar.subviews) {
            /// 隐藏掉蓝点
            if ([subView isKindOfClass:NSClassFromString(@"_UINavigationItemButtonView")]) {
                subView.mh_size = CGSizeZero;
                subView.hidden = YES;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Being popped, take a snapshot
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
    
    if (self.navigationController) {
        /**
         viewController.navigationItem.backBarButtonItem = nil;
         [viewController.navigationItem setHidesBackButton:YES];
         CoderMikeHe: Fixed Bug 上面这个方法，会导致侧滑取消时，导航栏出现三个蓝点，系统层面的BUg
         */
        for (UIView *subView in self.navigationController.navigationBar.subviews) {
            /// 隐藏掉蓝点
            if ([subView isKindOfClass:NSClassFromString(@"_UINavigationItemButtonView")]) {
                subView.mh_size = CGSizeZero;
                subView.hidden = YES;
            }
        }
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// ignore adjust auto scroll 64
    /// CoderMikeHe Fixed: 适配 iOS 11.0 , iOS11以后，控制器的automaticallyAdjustsScrollViewInsets已经废弃，所以默认就会是YES
    /// iOS 11新增：adjustContentInset 和 contentInsetAdjustmentBehavior 来处理滚动区域
    /// CoderMikeHe Fixed : __IPHONE_11_0 只是说明Xcode定义了这个宏，但不能说明这个支持11.0，所以需要@available(iOS 11.0, *)
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    /// backgroundColor
    self.view.backgroundColor = [UIColor colorFromHexString:@"#EFEFF4"];
    
    /// 导航栏隐藏 只能在ViewDidLoad里面加载，无法动态
    self.fd_prefersNavigationBarHidden = self.prefersNavigationBarHidden;
    
    /// pop手势
    self.fd_interactivePopDisabled = self.interactivePopDisabled;
}

#pragma mark - Public Method
- (void)configure{
    /// ... subclass override , but must use `[super configure]`
    /// 动态改变
    @weakify(self);
    [[[RACObserve(self, interactivePopDisabled) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.fd_interactivePopDisabled = x.boolValue;
    }];
}

- (void)requestRemoteData{
    /// ... subclass override
    
}

- (id)fetchLocalData{
    /// ... subclass override
    return nil;
}



#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }


@end
