//
//  CMHFileUploadManager.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/17.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMHFileSource.h"
/// 某资源的所有片数据上传，完成也就是提交资源到服务器成功。
FOUNDATION_EXTERN NSString *const CMHFileUploadDidFinishedNotification;
/// 资源文件上传状态改变的通知
FOUNDATION_EXTERN NSString *const CMHFileUploadStatusDidChangedNotification;

/// 草稿上传文件状态 disable 是否不能点击 如果为YES 不要修改草稿页表单的上传状态 主需要让用户不允许点击上传按钮
FOUNDATION_EXTERN NSString *const CMHFileUploadDisableStatusKey;
FOUNDATION_EXTERN NSString *const CMHFileUploadDisableStatusNotification;

/// 某资源中的某片数据上传完成
FOUNDATION_EXTERN NSString *const CMHFileUploadProgressDidChangedNotification;

/// 某资源的id
FOUNDATION_EXTERN NSString *const CMHFileUploadSourceIdKey;
/// 某资源的进度
FOUNDATION_EXTERN NSString *const CMHFileUploadProgressDidChangedKey;



@interface CMHFileUploadManager : NSObject

/// 存放操作队列的字典
@property (nonatomic , readonly , strong) NSMutableDictionary *uploadFileQueueDict;

/// 声明单例
+ (instancetype)sharedManager;

/// 销毁单例
+ (void)deallocManager;

/// 基础配置，主要是后台上传草稿数据  一般这个方法会放在 程序启动后切换到主页时调用
- (void)configure;

/// 上传资源
/// sourceId:文件组Id
- (void)uploadSource:(NSString *)sourceId;

/// 暂停上传 -- 用户操作
/// sourceId: 资源Id
- (void)suspendUpload:(NSString *)sourceId;

/// 继续上传 -- 用户操作
/// sourceId: 资源Id
- (void)resumeUpload:(NSString *)sourceId;

/// 取消掉上传 -- 用户操作
/// sourceId: 资源Id
- (void)cancelUpload:(NSString *)sourceId;

/// 取消掉所有上传 一般这个方法会放在 程序启动后切换到登录页时调用
- (void)cancelAllUpload;

/// 删除当前用户无效的资源
- (void)clearInvalidDiskCache;

//// 以下方法跟服务器交互，只管调用即可，无需回调，
/// 清除掉已经上传到服务器的文件片 fileSection
- (void)deleteUploadedFile:(NSString *)sourceId;

/// 告知草稿页，某个资源的上传状态改变
/// sourceId -- 资源ID
- (void)postFileUploadStatusDidChangedNotification:(NSString *)sourceId;
/// 告知草稿页，某个资源不允许点击
- (void)postFileUploadDisableStatusNotification:(NSString *)sourceId fileUploadDisabled:(BOOL)fileUploadDisabled;

/// 更新资源的状态
/// uploadStatus -- 上传状态
/// sourceId -- 资源ID
- (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId;

@end
