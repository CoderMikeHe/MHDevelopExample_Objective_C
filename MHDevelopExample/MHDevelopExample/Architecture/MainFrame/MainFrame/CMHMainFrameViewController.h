//
//  CMHMainFrameViewController.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  这个控制器模块主要是测试 CMHViewController 提供的属性，来适用一些常用的开发场景，为大家平常开发提供一点便捷。

#import "CMHTableViewController.h"
#import "CMHProfileButton.h"
@interface CMHMainFrameViewController : CMHTableViewController
/// 个人中心按钮
@property (nonatomic , readonly , strong) CMHProfileButton *profileBtn;
@end
