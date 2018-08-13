//
//  CMHUploadFileConstant.h
//  MHDevelopExample
//
//  Created by lx on 2018/8/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  常量

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 每片大小 512k
#define CMHFileFragmentMaxSize  512*1024

/// 文件片上传状态
typedef NS_ENUM(NSUInteger, CMHFileUploadStatus) {
    CMHFileUploadStatusWaiting = 0,     /// 准备上传
    CMHFileUploadStatusUploading,       /// 正在上传
    CMHFileUploadStatusFinished,        /// 上传完成
};


/// 最多上传50个文件
FOUNDATION_EXTERN NSInteger const CMHFileMaxCount ;
/// 上传资源存放的文件夹名称
FOUNDATION_EXTERN NSString *const CMHFileCacheDirName ;


/// 文件类型
typedef NS_ENUM(NSInteger, CMHFileType) {
    CMHFileTypeNone = -1,     /// 添加按钮
    CMHFileTypePicture = 0,   /// 图片
    CMHFileTypeVideo = 1,     /// 视频
};
