//
//  MHWebImageTool.h
//  MHNetworking
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  下载图片完成的block
 */
typedef void(^MHWebImageCompletionWithFinishedBlock)(UIImage * _Nullable image);
/**
 *  下载图片进度
 */
typedef void(^MHWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize,NSURL * _Nullable targetURL);


@interface MHWebImageTool : NSObject

/**
 *  异步获取图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView;


/**
 *  异步获取图片 返回下载成功的图片
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param imageView      图片显示控件 必须是强引用
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock;

/**
 *  异步获取图片 带进度
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param imageView      图片显示控件 必须是强引用
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView progress:(nullable MHWebImageDownloaderProgressBlock)progressBlock completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock;

/**
 *  异步下载图片 带进度
 *
 *  @param url            图片url
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable MHWebImageDownloaderProgressBlock)progressBlock completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock;



/**
 *  解决内存警告
 */
+ (void) clearWebImageCache;

@end
