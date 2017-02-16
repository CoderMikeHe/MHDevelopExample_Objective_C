//
//  UIImage+MHFile.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 图片保存...
 */

/**
 *  Tips
 
 保存 UIImage 有三种方式：
 1.直接用 NSKeyedArchiver 把 UIImage 序列化保存，
 2.用 UIImagePNGRepresentation() 先把图片转为 PNG 保存，
 3.用 UIImageJPEGRepresentation() 把图片压缩成 JPEG 保存。
 
 compare:
 NSKeyedArchiver 是调用了 UIImagePNGRepresentation 进行序列化的，用它来保存图片是消耗最大的。苹果对 JPEG 有硬编码和硬解码，保存成 JPEG 会大大缩减编码解码时间，也能减小文件体积。所以如果图片不包含透明像素时，UIImageJPEGRepresentation(0.9) 是最佳的图片保存方式，其次是 UIImagePNGRepresentation()。
 */
#import <UIKit/UIKit.h>

@interface UIImage (MHFile)

@end
