//
//  CMHWaterfall.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"

@interface CMHWaterfall : CMHObject

/// title
@property (nonatomic , readwrite , copy) NSString *title;
/// imageUrl
@property (nonatomic , readwrite , copy) NSString *imageUrl;
/// 宽
@property (nonatomic , readwrite , assign) CGFloat width;
/// 高
@property (nonatomic , readwrite , assign) CGFloat height;
@end
