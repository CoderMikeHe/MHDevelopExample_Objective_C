//
//  CMHFile.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  文件<图片 or 视频>

#import "CMHObject.h"
#import "CMHUploadFileConstant.h"


@interface CMHFile : CMHObject

/// fileId 文件上传ID ,通过`/fileSection/preLoad.do`接口获取
@property (nonatomic , readwrite , copy) NSString *fileId;

/// fileType
@property (nonatomic , readwrite , assign) CMHFileType fileType;

/// 本地文件路径 <图片，视频>
@property (nonatomic , readwrite , copy) NSString *filePath;

/// thumbImage 缩略图
@property (nonatomic , readwrite , strong) UIImage *thumbImage;

/// localIdentifier <iOS 8.0 + 以后的版本  PHAsset 的唯一标识 ，用这个去获取 PHAsset对象，但是可能会因为用户从相册中删除，而获取不到 PHAsset>
@property (nonatomic , readwrite , copy) NSString *localIdentifier;

/// 不支持预览 <已经不存在相册了> NO : 支持预览 YES : 不支持预览 （PS：该属性是在编辑资源的情况下设置，非编辑的情况下，不需要设置）
@property (nonatomic , readwrite , assign) BOOL disablePreview;

/// 将图片写入磁盘
/// return -- 文件相对路径(filePath) 可为nil
+ (NSString *)writePictureFileToDisk:(NSData *)srcData;
/// 将某个文件移动到指定的文件夹中,主要作用就是将录制或者选择的视频文件，移动到指定的文件
/// return -- 文件相对路径(filePath) 可为nil
+ (NSString *)moveVideoFileAtPath:(NSString *)srcPath;

@end
