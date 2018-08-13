//
//  CMHFileBlock.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  文件块

#import <Foundation/Foundation.h>
#import "CMHFileFragment.h"
#import "CMHFile.h"
@interface CMHFileBlock : NSObject

/// 文件资源ID
@property (nonatomic , readonly , copy) NSString *sourceId;
/// 文件块ID
@property (nonatomic , readonly , copy) NSString *fileId;
/// 包括文件后缀名的文件名
@property (nonatomic , readonly , copy) NSString *fileName;
/// 文件所在路径 <相对路径>
@property (nonatomic , readonly , copy) NSString *filePath;
/// fileType 文件类型
@property (nonatomic , readonly , assign) CMHFileType fileType;


/// 文件块总大小 --- 对应接口<`totalSize`>
@property (nonatomic , readonly , assign) NSInteger totalFileSize;
/// 文件块总片数 --- 对应接口<`blockTotal`>
@property (nonatomic , readonly , assign) NSInteger totalFileFragment;
/// 文件分片数组
@property (nonatomic , readonly , copy) NSArray <CMHFileFragment*> *fileFragments;


/**
 初始化文件块
 @param path 文件所处Cache文件夹的相对路径
 @param fileId 文件ID
 @param sourceId 资源ID
 @return 文件块
 */
- (instancetype)initFileBlcokAtPath:(NSString *)path
                             fileId:(NSString *)fileId
                           sourceId:(NSString *)sourceId;

@end
