//
//  NSString+MHSize.h
//  JiuluTV
//
//  Created by CoderMikeHe on 16/12/7.
//  Copyright © 2016年 9lmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MHSize)

/**
 *  动态计算文字的宽高（单行）
 *
 *  @param font 文字的字体
 *
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithFont:(UIFont *)font;


@end
