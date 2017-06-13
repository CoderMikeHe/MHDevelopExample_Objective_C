//
//  MHNavigationController.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHNavigationController : UINavigationController
/// 导航栏分隔线
@property (nonatomic , weak , readonly) UIImageView * navSystemLine;

/// 显示导航栏的细线
- (void)showNavgationSystemLine;
/// 隐藏导航栏的细线
- (void)hideNavgationSystemLine;


@end
