//
//  SUBaseViewController.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUBaseViewController.h"

@interface SUBaseViewController ()

@end

@implementation SUBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef __IPHONE_11_0
    /// ignore adjust scroll 64
    self.automaticallyAdjustsScrollViewInsets = YES;
#else
    /// ignore adjust scroll 64
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    

    
    self.extendedLayoutIncludesOpaqueBars = YES;
    /// backgroundColor
    self.view.backgroundColor = SUGlobalGrayBackgroundColor;
}

#pragma mark - Orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {return UIInterfaceOrientationMaskPortrait;}
- (BOOL)shouldAutorotate {return YES;}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {return UIInterfaceOrientationPortrait;}

#pragma mark - Status bar
- (BOOL)prefersStatusBarHidden { return NO; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleDefault; }
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation { return UIStatusBarAnimationFade; }

@end
