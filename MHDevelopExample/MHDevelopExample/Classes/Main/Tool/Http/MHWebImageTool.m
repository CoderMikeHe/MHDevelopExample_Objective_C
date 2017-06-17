//
//  MHWebImageTool.m
//  MHNetworking
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MHWebImageTool.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation MHWebImageTool

+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView
{
    [self setImageWithURL:url placeholderImage:placeholder imageView:imageView completed:nil];
}


+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder imageView:imageView progress:nil completed:completedBlock];
}


+ (void)setImageWithURL:(nullable NSString *)url placeholderImage:(nullable UIImage *)placeholder imageView:(nullable UIImageView *)imageView progress:(nullable MHWebImageDownloaderProgressBlock)progressBlock completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock
{
    if (MHObjectIsNil(url)) {
        url = nil;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}


+ (void)downloadImageWithURL:(nullable NSString *)url progress:(nullable MHWebImageDownloaderProgressBlock)progressBlock completed:(nullable MHWebImageCompletionWithFinishedBlock)completedBlock
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize,targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}
+ (void) clearWebImageCache
{
    // 赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        NSLog(@"**** Async clear all disk cached images ****");
        
    }];
    
    // 赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}
@end
