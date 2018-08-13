//
//  CMHFileFragment.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  

#import "CMHFileFragment.h"
#import <BGFMDB/BGFMDB.h>
@implementation CMHFileFragment

/// 获取请求头信息
- (NSDictionary *)fetchUploadParamsInfo{
    
    /// 拼接服务器所需的上传参数
    /// {'id':'43','totalSize':19232,'blockTotal':2,'blockNo':1}
    return @{
             @"id"        : self.fileId,
             @"totalSize" : @(self.totalFileSize),
             @"blockTotal": @(self.totalFileFragment),
             @"blockNo"   : @(self.fragmentIndex + 1)
             };
}

/// 获取文件大小
- (NSData *)fetchFileFragmentData{

    NSData *data = nil;
    /// 资源文件的绝对路径
    NSString *absolutePath = [[CMHFileManager cachesDir] stringByAppendingPathComponent:self.filePath];

    if ([CMHFileManager isExistsAtPath:absolutePath]) {
        NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:absolutePath];
        [readHandle seekToFileOffset:self.fragmentOffset];
        /// 读取文件
        data = [readHandle readDataOfLength:self.fragmentSize];
        /// CoderMikeHe Fixed Bug: 获取了数据，要关闭文件
        [readHandle closeFile];
    }else{
        NSLog(@"😭😭😭+++ 上传文件不存在 +++😭😭😭》〉");
    }
    return data;
}
#pragma mark - 数据库操作
/// 删除文件片
+ (void)removeFileFragmentFromDB:(NSString *)sourceId complete:(void (^)(BOOL))complete{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    [self bg_deleteAsync:nil where:where complete:^(BOOL isSuccess) {
        /// 移除所有的文件片
        !complete ? : complete(isSuccess);
    }];
}

/// 获取该资源下所有待上传的文件片<除了上传完成状态的所有片>
+ (NSArray *)fetchAllWaitingForUploadFileFragment:(NSString *)sourceId{
    /// 条件语句
    NSString *where = [NSString stringWithFormat:@"where %@ != %@ and %@ = %@",bg_sqlKey(@"uploadStatus"),bg_sqlValue(@(CMHFileUploadStatusFinished)),bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    /// 查询
    NSArray *array = [self bg_find:nil where:where];
    /// 返回数据
    return MHObjectIsNil(array)?@[]:array;
}

/// 更新某一文件片的上传状态
- (void)updateFileFragmentUploadStatus:(CMHFileUploadStatus)uploadStatus{
    /// 条件语句
    NSString * where = [NSString stringWithFormat:@"set %@ = %@ where %@ = %@ and %@ = %@",bg_sqlKey(@"uploadStatus"),bg_sqlValue(@(uploadStatus)),bg_sqlKey(@"fileId"),bg_sqlValue(self.fileId),bg_sqlKey(@"fragmentIndex"),bg_sqlValue(@(self.fragmentIndex))];
    /// 更新
    [CMHFileFragment bg_update:nil where:where];
}

@end
