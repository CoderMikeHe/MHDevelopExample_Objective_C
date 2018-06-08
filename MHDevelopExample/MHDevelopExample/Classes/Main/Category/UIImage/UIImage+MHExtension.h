//
//  UIImage+MHExtension.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 图片...
 */


#import <UIKit/UIKit.h>

@interface UIImage (MHExtension)
/**
 *  根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
 */
+ (UIImage *)mh_resizableImage:(NSString *)imgName;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)mh_resizableImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/**
 *  获取视频第一帧图片
 */
+ (UIImage *) mh_getVideoFirstThumbnailImageWithVideoUrl:(NSURL *)videoUrl;
/**
 *  图片不被渲染
 *
 */
+ (UIImage *)mh_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName;

/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 *  图片着色
 */
+ (UIImage *)mh_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color;
/**
 *  根据指定的图片颜色和图片大小获取指定的Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 */
+ (UIImage *)mh_getImageWithColor:(UIColor *)color size:(CGSize)size;
/**
 *  通过传入一个图片对象获取一张缩略图
 */
+ (UIImage *)mh_getThumbnailImageWithImageObj:(id)imageObj;

/**
 *  通过传入一个图片对象获取一张原始图
 */
+ (UIImage *)mh_getOriginalImageWithImageObj:(id)imageObj;
@end
