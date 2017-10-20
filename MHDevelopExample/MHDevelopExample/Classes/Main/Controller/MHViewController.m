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
    // 初始化
    [self _baseSetup];
}


#pragma mark - 私有方法
// 不要让子类的方法跟这一样 否则覆盖 
- (void)_baseSetup
{
    self.view.backgroundColor = MHGlobalGrayBackgroundColor;
}

@end
