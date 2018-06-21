//
//  SAMKeychain+CMHUtil.h
//  WeChat
//
//  Created by senba on 2017/10/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <SAMKeychain/SAMKeychain.h>

@interface SAMKeychain (CMHUtil)
+ (NSString *)rawLogin ;

+ (BOOL)setRawLogin:(NSString *)rawLogin ;

+ (BOOL)deleteRawLogin;



/// 设备ID or UUID
+ (NSString *)deviceId;
@end
