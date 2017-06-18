//
//  SULoginViewModel1.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的 `登录界面的视图模型` -- VM

#import "SUViewModel1.h"

@interface SULoginViewModel1 : SUViewModel1

/// 手机号
@property (nonatomic, readwrite, copy) NSString *mobilePhone;

/// 验证码
@property (nonatomic, readwrite, copy) NSString *verifyCode;

/// 登录按钮的点击状态
@property (nonatomic, readonly, assign) BOOL validLogin;

/// 用户头像
@property (nonatomic, readonly, copy) NSString *avatarUrlString;

/// 用户登录 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)loginSuccess:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure;

@end
