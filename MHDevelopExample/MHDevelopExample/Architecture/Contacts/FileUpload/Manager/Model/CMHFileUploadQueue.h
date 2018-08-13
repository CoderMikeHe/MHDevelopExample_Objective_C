//
//  CMHFileUploadQueue.h
//  MHDevelopExample
//
//  Created by lx on 2018/8/6.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  上传文件资源队列

#import <Foundation/Foundation.h>

@interface CMHFileUploadQueue : NSOperationQueue
/// 用户手动暂停 默认是NO
@property (nonatomic , readwrite , assign , getter = isManualPause) BOOL manualPause;
@end
