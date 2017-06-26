//
//  SULoginViewModel2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的 `登录界面的视图模型` -- VM

#import "SULoginViewModel2.h"


@interface SULoginViewModel2 ()

/// 用户头像
@property (nonatomic, readwrite, copy) NSString *avatarUrlString;

/// 按钮能否点击
@property (nonatomic, readwrite, strong) RACSignal *validLoginSignal;

/// 登录按钮点击执行的命令
@property (nonatomic, readwrite, strong) RACCommand *loginCommand;

@end

@implementation SULoginViewModel2

- (void)initialize
{
    [super initialize];
    @weakify(self);
    
    /// 数据绑定
    RAC(self, avatarUrlString) = [[RACObserve(self, mobilePhone)
                             map:^NSString *(NSString * mobilePhone) {
                                /// 模拟从数据库获取用户头像的数据
                                /// 假数据 别在意
                                return ![NSString mh_isValidMobile:mobilePhone]?nil:[AppDelegate sharedDelegate].account.avatarUrl;
                                 
                             }]
                            distinctUntilChanged];
  
    /// 按钮有效性
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, mobilePhone), RACObserve(self, verifyCode) ]
                              reduce:^(NSString *mobilePhone, NSString *verifyCode) {
                                  return @(mobilePhone.length > 0 && verifyCode.length > 0);
                              }]
                             distinctUntilChanged];
    
    /// 登录命令
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        // 这里手机号以及验证码在控制器那里也可以在视图控制器筛选，但同时也可以在viewModel中处理
        // 最好的写法:button.rac_command = viewmodel.loginCommand...把位数判断移到这里
        if (![NSString mh_isValidMobile:self.mobilePhone]) {
           
            return [RACSignal error:[NSError errorWithDomain:SUCommandErrorDomain code:SUCommandErrorCode userInfo:@{SUCommandErrorUserInfoKey:@"请输入正确的手机号码"}]];
        }
        if (![NSString mh_isPureDigitCharacters:self.verifyCode] || self.verifyCode.length != 4 ) {
            
            return [RACSignal error:[NSError errorWithDomain:SUCommandErrorDomain code:SUCommandErrorCode userInfo:@{SUCommandErrorUserInfoKey:@"验证码错误"}]];
        }
        @weakify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            @weakify(self);
            /// 发起请求 模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                /// 登录成功 保存数据 简单起见 随便存了哈
                [[NSUserDefaults standardUserDefaults] setValue:self.mobilePhone forKey:SULoginPhoneKey2];
                [[NSUserDefaults standardUserDefaults] setValue:self.verifyCode forKey:SULoginVerifyCodeKey2];
                [[NSUserDefaults standardUserDefaults] synchronize];
                /// 保存用户数据 这个逻辑就不要我来实现了吧 假数据参照 [AppDelegate sharedDelegate].account
                /// 模拟成功或者失败 1 success 0 failure
#if 1
                [subscriber sendNext:nil];
                /// 必须sendCompleted 否则command.executing一直为1 导致HUD 一直 loading
                [subscriber sendCompleted];
#else
                /// 失败的回调 我就不处理 现实中开发绝逼不是这样的
                [subscriber sendError:[NSError errorWithDomain:SUCommandErrorDomain code:SUCommandErrorCode userInfo:@{SUCommandErrorUserInfoKey:@"呜呜，服务器不给力呀..."}]];
#endif
            });
            
            return nil;
        }];
    }];
}

@end
