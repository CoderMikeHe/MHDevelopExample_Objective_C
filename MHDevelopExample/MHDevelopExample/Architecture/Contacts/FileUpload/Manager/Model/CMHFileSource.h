//
//  CMHFileSource.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  一份文件资源<CMHFileSource> = 文件块0<CMHFileBlock>  + 文件块1<CMHFileBlock> + 文件块2<CMHFileBlock> + ....
//  一个文件块<CMHFileBlock> = 文件片0<CMHFileFragment> + 文件片1<CMHFileFragment> + 文件片2<CMHFileFragment> + ....

#import <Foundation/Foundation.h>
#import "CMHFileBlock.h"


@interface CMHFileSource : NSObject
/// 文件资源ID 手动设置
@property (nonatomic , readwrite , copy) NSString *sourceId;
/// 文件资源总大小 <所有文件块的总大小之和> 无需手动设置
@property (nonatomic , readwrite , assign) NSInteger totalFileSize;
/// 文件资源总片数 <所有文件块的总片数之和> 无需手动设置
@property (nonatomic , readwrite , assign) NSInteger totalFileFragment;
/// 上传完成成功的总片数 通过数据库设置
@property (nonatomic , readwrite , assign) NSInteger totalSuccessFileFragment;
/// 字符串数组，文件ID列表，服务器返回的文件ID列表 手动设置
@property (nonatomic , readwrite , copy) NSString *fileIds;
/// fileBlocks (该资源下的所有文件块) 主要赋值这个 手动设置
@property (nonatomic , readwrite , copy) NSArray <CMHFileBlock *> *fileBlocks;
/// fileFragments 该资源下的所有文件片 无需手动设置
@property (nonatomic , readwrite , copy) NSArray <CMHFileFragment *> *fileFragments;
/// 上传状态 <默认是CMHFileUploadStatusWaiting>
@property (nonatomic , readwrite, assign) CMHFileUploadStatus uploadStatus;



#pragma mark - 数据库操作
/// 保存到数据库 <这里内部还保存了 文件片>
- (void)saveFileSourceToDB:(void(^_Nullable)(BOOL isSuccess))complete;
/// 保存到数据库 只保存 CMHFileSource
- (void)saveOrUpdate;

/// 删除上传资源
/// complete -- 完成的回调
+ (void)removeFileSourceFromDB:(NSString *)sourceId complete:(void(^_Nullable)(BOOL isSuccess))complete;

/// 更新上传完成数量
/// sourceId -- 资源ID
+ (void)updateTotalSuccessFileFragment:(NSString *)sourceId;

/// 更新上传资源的上传状态
/// sourceId -- 资源ID
+ (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId;

/// 获取资源的上传进度
/// sourceId -- 资源ID
+ (CGFloat)fetchUploadProgress:(NSString *)sourceId;

/// 获取上传结果
/// sourceId -- 资源ID
+ (CMHFileUploadStatus)fetchFileUploadStatus:(NSString *)sourceId;

/// 获取上传资源
/// sourceId -- 资源ID
+ (CMHFileSource *)fetchFileSource:(NSString *)sourceId;

/// 回滚该资源中失败的文件 <一般是后台返回的数据>
/// failFileIds -- 合成失败的文件ID列表
- (void)rollbackFailureFile:(NSArray *)failFileIds;
@end
