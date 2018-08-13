//
//  CMHFileBlock.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileBlock.h"

@interface CMHFileBlock ()
/// 文件资源ID
@property (nonatomic , readwrite , copy) NSString *sourceId;
/// 文件块ID
@property (nonatomic , readwrite , copy) NSString *fileId;
/// 包括文件后缀名的文件名
@property (nonatomic , readwrite, copy)  NSString *fileName;
/// fileType 文件类型
@property (nonatomic , readwrite , assign) CMHFileType fileType;
/// 文件块总大小 --- 对应接口<`totalSize`>
@property (nonatomic , readwrite , assign) NSInteger totalFileSize;
/// 文件块总片数 --- 对应接口<`blockTotal`>
@property (nonatomic , readwrite , assign) NSInteger totalFileFragment;
/// 文件所在路径
@property (nonatomic, readwrite, copy) NSString *filePath;
/// 文件分片数组
@property (nonatomic, readwrite, copy) NSArray <CMHFileFragment*> *fileFragments;

@end

@implementation CMHFileBlock

- (instancetype)initFileBlcokAtPath:(NSString *)path
                             fileId:(NSString *)fileId
                           sourceId:(NSString *)sourceId{
    if (self = [super init]) {
        /// 验证路径的有效性
        if (![self _fetchFileInfoAtPath:path]) {
            return nil;
        }
        self.fileId = fileId;
        self.sourceId = sourceId;
        
        /// 切片
        [self _cutFileForFragments];
    }
    return self;
}



/// 获取文件信息
- (BOOL)_fetchFileInfoAtPath:(NSString*)path {
    
    /// 验证文件存在
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    /// 拼接路径，path 是相对路径
    NSString * absolutePath = [[CMHFileManager cachesDir] stringByAppendingPathComponent:path];
    if (![fileMgr fileExistsAtPath:absolutePath]) {
        NSLog(@"+++ 文件不存在 +++：%@",absolutePath);
        return NO;
    }
    /// 存取文件路径
    self.filePath = path;
    
    /// 文件大小
    NSDictionary *attr =[fileMgr attributesOfItemAtPath:absolutePath error:nil];
    self.totalFileSize = attr.fileSize;
    
    /// 文件名
    NSString *fileName = [path lastPathComponent];
    self.fileName = fileName;
    
    /// 文件类型
    self.fileType = ([fileName.pathExtension.lowercaseString isEqualToString:@"mp4"]) ? CMHFileTypeVideo:CMHFileTypePicture;
    
    return YES;
}

#pragma mark - 读操作
// 切分文件片段
- (void)_cutFileForFragments {
    
    NSUInteger offset = CMHFileFragmentMaxSize;
    // 总片数
    NSUInteger totalFileFragment = (self.totalFileSize%offset==0)?(self.totalFileSize/offset):(self.totalFileSize/(offset) + 1);
    self.totalFileFragment = totalFileFragment;
    NSMutableArray<CMHFileFragment *> *fragments = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSUInteger i = 0; i < totalFileFragment; i ++) {
        
        CMHFileFragment *fFragment = [[CMHFileFragment alloc] init];
        fFragment.fragmentIndex = i;
        fFragment.uploadStatus = CMHFileUploadStatusWaiting;
        fFragment.fragmentOffset = i * offset;
        if (i != totalFileFragment - 1) {
            fFragment.fragmentSize = offset;
        } else {
            fFragment.fragmentSize = self.totalFileSize - fFragment.fragmentOffset;
        }
        
        /// 关联属性
        fFragment.fileId = self.fileId;
        fFragment.sourceId = self.sourceId;
        fFragment.filePath = self.filePath;
        fFragment.totalFileFragment = self.totalFileFragment ;
        fFragment.totalFileSize = self.totalFileSize;
        
        fFragment.fileType = self.fileType;
        fFragment.fileName = [NSString stringWithFormat:@"%@-%ld.%@",self.fileId , (long)i , self.fileName.pathExtension];
        
        
        [fragments addObject:fFragment];
    }
    self.fileFragments = fragments.copy;
}

@end
