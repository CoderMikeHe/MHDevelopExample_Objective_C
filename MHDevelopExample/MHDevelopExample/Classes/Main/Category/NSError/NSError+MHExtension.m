//
//  NSError+MHExtension.m
//  SenbaUsed
//
//  Created by senba on 2017/5/22.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "NSError+MHExtension.h"

@implementation NSError (MHExtension)
+ (NSString *)mh_tipsFromError:(NSError *)error{
    if (!error) return nil;
    NSString *tipStr = nil;
    /// 这里需要处理HTTP请求的错误
    if (error.userInfo[CMHHTTPServiceErrorDescriptionKey]) {
        tipStr = [error.userInfo objectForKey:CMHHTTPServiceErrorDescriptionKey];
    }else if (error.domain) {
        tipStr = error.localizedFailureReason;
    } else {
        tipStr = error.localizedDescription;
    }
    return tipStr;
}
@end
