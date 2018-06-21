//
//  SAMKeychain+CMHUtil.m
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SAMKeychain+CMHUtil.h"

/// 登录账号的key
static NSString *const CMH_RAW_LOGIN = @"CMHRawLogin";
static NSString *const CMH_SERVICE_NAME_IN_KEYCHAIN = @"com.CoderMikeHe.DevelopExample";
static NSString *const CMH_DEVICEID_ACCOUNT         = @"DeviceID";

@implementation SAMKeychain (CMHUtil)
+ (NSString *)rawLogin {
    return [[NSUserDefaults standardUserDefaults] objectForKey:CMH_RAW_LOGIN];
}
+ (BOOL)setRawLogin:(NSString *)rawLogin {
    if (rawLogin == nil) NSLog(@"+setRawLogin: %@", rawLogin);
    
    [[NSUserDefaults standardUserDefaults] setObject:rawLogin forKey:CMH_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}
+ (BOOL)deleteRawLogin {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CMH_RAW_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


+ (NSString *)deviceId{
    NSString * deviceidStr = [SAMKeychain passwordForService:CMH_SERVICE_NAME_IN_KEYCHAIN account:CMH_DEVICEID_ACCOUNT];
    if (deviceidStr == nil) {
        deviceidStr = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [SAMKeychain setPassword:deviceidStr forService:CMH_SERVICE_NAME_IN_KEYCHAIN account:CMH_DEVICEID_ACCOUNT];
    }
    return deviceidStr;
}
@end
