//
//  CMHSource.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"
#import "CMHFile.h"
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.





//// ------ 通知 ----
/// 表单保存成功
FOUNDATION_EXTERN NSString *const CMHSaveSourceToDBSuccessNotification;
/// 表单数据
FOUNDATION_EXTERN NSString *const CMHSaveSourceToDBSuccessInfoKey;

/// 假设当前登录的用户的ID <PS: 这里写死，>
FOUNDATION_EXTERN NSString *const CMHCurrentUserIdStr;

@interface CMHSource : CMHObject
#pragma mark - 需要存储的属性
/// userId
@property (nonatomic , readwrite , copy) NSString *userId;

/// 资源id
@property (nonatomic , readwrite , copy) NSString *sourceId;

/// 资源标题
@property (nonatomic , readwrite , copy) NSString *title;

/// 封面url
@property (nonatomic , readwrite , copy) NSString *coverUrl;

/// 图片/视频资源组
@property (nonatomic , readwrite , copy) NSArray <CMHFile *> *files;

/// 用户选择了是否选择了原图
@property (nonatomic , readwrite , assign , getter = isSelectOriginalPhoto) BOOL selectOriginalPhoto;

/// 是否是手动保存草稿
@property (nonatomic , readwrite , assign , getter = isManualSaveDraft) BOOL manualSaveDraft;
/// yyyy-MM-dd HH:mm:ss <创建时间> 开发者无需设置
@property (nonatomic , readwrite , copy) NSString *createDate;

/// 上传状态 <默认是CMHFileUploadStatusWaiting>
@property (nonatomic , readwrite, assign) CMHFileUploadStatus uploadStatus;

// 表单上传完成的进度
@property (nonatomic , readwrite , assign) CGFloat progress;


#pragma mark - 无需存储的属性
/// 草稿点击按钮可否点击
@property (nonatomic , readwrite , assign) BOOL disable;


#pragma mark - 数据库操作
/// 保存到数据库
- (void)saveSourceToDB:(void(^_Nullable)(BOOL isSuccess))complete;

/// 删除资源
+ (void)removeSourceFromDB:(NSString *)sourceId complete:(void(^_Nullable)(BOOL isSuccess))complete;

/// 获取所有的草稿数据
+ (void)fetchAllDrafts:(void (^_Nullable)(NSArray * _Nullable array))complete;

/// 获取所有要上传的草稿资源
+ (NSArray *)fetchAllNeedUploadDraftData;


/// 获取资源
+ (CMHSource *)fetchSource:(NSString *)sourceId;

/// 更新上传资源的上传状态
/// sourceId -- 资源ID
+ (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId;

/// 更新资源的进度
/// progress -- 进度
/// sourceId -- 资源ID
+ (void)updateSourceProgress:(CGFloat)progress sourceId:(NSString *)sourceId;

#pragma mark - Method
/// 提交资源
- (void)commitSource:(void (^)(BOOL isSuccess))result;
+ (void)commitSource:(NSString *)sourceId;
@end
