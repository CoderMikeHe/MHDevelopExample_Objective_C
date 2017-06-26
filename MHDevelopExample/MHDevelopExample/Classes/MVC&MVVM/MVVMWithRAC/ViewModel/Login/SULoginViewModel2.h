//
//  SULoginViewModel2.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的 `登录界面的视图模型` -- VM

#import "SUViewModel2.h"

@interface SULoginViewModel2 : SUViewModel2

/// 手机号
@property (nonatomic, readwrite, copy) NSString *mobilePhone;

/// 验证码
@property (nonatomic, readwrite, copy) NSString *verifyCode;

/// 用户头像
@property (nonatomic, readonly, copy) NSString *avatarUrlString;

/// 按钮能否点击
@property (nonatomic, readonly, strong) RACSignal *validLoginSignal;

/// 登录按钮点击执行的命令
@property (nonatomic, readonly, strong) RACCommand *loginCommand;


@end
