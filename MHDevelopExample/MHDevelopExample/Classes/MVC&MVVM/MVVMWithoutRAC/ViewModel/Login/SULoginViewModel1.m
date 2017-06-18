//
//  SULoginViewModel1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/14.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SULoginViewModel1.h"

@interface SULoginViewModel1 ()
/// 用户头像
@property (nonatomic, readwrite, copy) NSString *avatarUrlString;
@end

@implementation SULoginViewModel1
{
    FBKVOController *_KVOController;
}

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    [_KVOController mh_observe:self keyPath:@"mobilePhone" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSString *mobilePhone = change[NSKeyValueChangeNewKey];
        if (![NSString mh_isValidMobile:mobilePhone]) {
            self.avatarUrlString = nil;
            return ;
        }
        /// 模拟从数据库获取用户头像的数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 假数据 别在意
            self.avatarUrlString = [AppDelegate sharedDelegate].account.avatarUrl;
        });
    }];
}


- (void)loginSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    /// 发起请求 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 登录成功 保存数据 简单起见 随便存了哈
        [[NSUserDefaults standardUserDefaults] setValue:self.mobilePhone forKey:SULoginPhoneKey1];
        [[NSUserDefaults standardUserDefaults] setValue:self.verifyCode forKey:SULoginVerifyCodeKey1];
        [[NSUserDefaults standardUserDefaults] synchronize];
        /// 保存用户数据 这个逻辑就不要我来实现了吧 假数据参照 [AppDelegate sharedDelegate].account
        
        /// 失败的回调 我就不处理 现实中开发绝逼不是这样的
        !success?:success([AppDelegate sharedDelegate].account);
    });
}

- (BOOL)validLogin
{
     return (MHStringIsNotEmpty(self.mobilePhone) && MHStringIsNotEmpty(self.verifyCode));
}
@end
