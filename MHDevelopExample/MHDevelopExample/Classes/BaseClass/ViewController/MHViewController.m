//
//  MHViewController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHViewController.h"

@interface MHViewController ()

@end

@implementation MHViewController

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
    /// 推荐使用
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    /// backgroundColor
    self.view.backgroundColor = MHGlobalGrayBackgroundColor;
}


#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }
@end
