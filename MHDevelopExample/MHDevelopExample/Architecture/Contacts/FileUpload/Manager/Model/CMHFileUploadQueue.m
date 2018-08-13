//
//  CMHFileUploadQueue.m
//  MHDevelopExample
//
//  Created by lx on 2018/8/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileUploadQueue.h"

@implementation CMHFileUploadQueue
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 每次只执行一个任务 串行队列
        [self setMaxConcurrentOperationCount:1];
    }
    return self;
}



@end
