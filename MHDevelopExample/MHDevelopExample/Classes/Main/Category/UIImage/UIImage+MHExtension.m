//
//  UIImage+MHExtension.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIImage+MHExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


static NSTimeInterval const MHThumbnailImageTime = 10.0f;

@implementation UIImage (MHExtension)
/**
 *  根据图片名返回一张能够自由拉伸的图片 (从中间拉伸)
 */
+ (UIImage *)mh_resizableImage:(NSString *)imgName
{
    return [self mh_resizableImage:imgName xPos:0.5 yPos:0.5];;
}

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)mh_resizableImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

/**
 *  获取视频第一帧图片
 */
+ (UIImage *)mh_getVideoFirstThumbnailImageWithVideoUrl:(NSURL *)videoUrl
{
    AVURLAsset*asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = nil;
    CFTimeInterval thumbnailImageTime = MHThumbnailImageTime;
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 1.0f) actualTime:nil error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
    {
        NSLog(@"======thumbnailImageGenerationError======= %@",thumbnailImageGenerationError);
    }
    
    return thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
}

/**
 *  图片不被渲染
 *
 */
+ (UIImage *)mh_imageAlwaysShowOriginalImageWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)])
    {   //iOS 7.0+
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        return image;
    }
}

/**
 *  根据图片和颜色返回一张加深颜色以后的图片
 *  图片着色
 */
+ (UIImage *)mh_colorizeImageWithSourceImage:(UIImage *)sourceImage color:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(sourceImage.size.width*2, sourceImage.size.height*2));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, sourceImage.size.width * 2, sourceImage.size.height * 2);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, sourceImage.CGImage);
    
    [color set];
    
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, sourceImage.CGImage);
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return destImage;

}


/**
 *  根据指定的图片颜色和图片大小获取指定的Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 */
+ (UIImage *)mh_getImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}



/**
 *  通过传入一个图片对象获取一张缩略图
 */
+ (UIImage *)mh_getThumbnailImageWithImageObj:(id)imageObj
{
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[ALAsset class]]){
        @autoreleasepool {
            ALAsset *asset = (ALAsset *)imageObj;
            return [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        }
    }
    return image;
}

/**
 *  通过传入一个图片对象获取一张原始图
 */
+ (UIImage *)mh_getOriginalImageWithImageObj:(id)imageObj
{
    __block UIImage *image = nil;
    if ([imageObj isKindOfClass:[UIImage class]]) {
        return imageObj;
    }else if ([imageObj isKindOfClass:[ALAsset class]]){
        @autoreleasepool {
            ALAsset *asset = (ALAsset *)imageObj;
            return [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }
    }
    return image;
}


@end
