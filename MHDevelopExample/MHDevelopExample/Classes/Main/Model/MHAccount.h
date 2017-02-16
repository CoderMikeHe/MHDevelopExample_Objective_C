//
//  MHAccount.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  用户数据模型

#import <Foundation/Foundation.h>

@interface MHAccount : NSObject

/** userId */
@property (nonatomic , copy) NSString *userId;

/** 用户昵称 */
@property (nonatomic , copy) NSString *nickname;

/** 头像地址 */
@property (nonatomic , copy) NSString *avatarUrl;

@end
