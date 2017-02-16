//
//  MHAccount.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHAccount.h"

@implementation MHAccount

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _nickname = @"CoderMikeHe";
        _userId = @"1000";
        _avatarUrl = @"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=1206211006,1884625258&fm=58";
        
    }
    return self;
}


@end
