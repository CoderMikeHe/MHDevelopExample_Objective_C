//
//  CMHFileFragment.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  文件片 <上传过程中，主要是处理这个>

#import <Foundation/Foundation.h>
#import "CMHUploadFileConstant.h"




@interface CMHFileFragment : NSObject

/// 片的大小
@property (nonatomic , readwrite, assign) NSUInteger fragmentSize;
/// 片的偏移量
@property (nonatomic , readwrite, assign) NSUInteger fragmentOffset;
/// 片的索引 --- 对应接口<`blockNo` 从1开始>
@property (nonatomic , readwrite , assign) NSUInteger fragmentIndex;
/// 上传状态 <默认是CMHFileUploadStatusWaiting>
@property (nonatomic , readwrite, assign) CMHFileUploadStatus uploadStatus;

/// 文件资源ID
@property (nonatomic , readwrite , copy) NSString *sourceId;
/// 文件块ID --- 对应接口<`id`>
@property (nonatomic , readwrite , copy) NSString *fileId;
/// 该文件片所处的文件块总大小 --- 对应接口<`totalSize`>
@property (nonatomic , readwrite , assign) NSInteger totalFileSize;
/// 该文件片所处的文件块总片数 --- 对应接口<`blockTotal`>
@property (nonatomic , readwrite , assign) NSInteger totalFileFragment;
/// 该文件片所处的文件块的文件路径
@property (nonatomic , readwrite , copy) NSString *filePath;

/// 包括文件后缀名的文件名
@property (nonatomic , readwrite , copy) NSString *fileName;
/// fileType 文件类型
@property (nonatomic , readwrite , assign) CMHFileType fileType;

#pragma mark - Method
/// 获取请求头信息
- (NSDictionary *)fetchUploadParamsInfo;
/// 获取文件大小
- (NSData *)fetchFileFragmentData;

#pragma mark - 数据库操作
/// 删除上传文件片
/// complete -- 完成回调
+ (void)removeFileFragmentFromDB:(NSString *)sourceId complete:(void(^_Nullable)(BOOL isSuccess))complete;

/// 获取该资源下所有待上传的文件片<除了上传完成状态的所有片>
/// sourceId -- 资源ID
+ (NSArray *)fetchAllWaitingForUploadFileFragment:(NSString *)sourceId;

/// 更新某一文件片的上传状态
/// uploadStatus -- 上传状态
- (void)updateFileFragmentUploadStatus:(CMHFileUploadStatus)uploadStatus;
@end
