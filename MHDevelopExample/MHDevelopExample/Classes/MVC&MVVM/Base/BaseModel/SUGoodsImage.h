//
//  SUGoodsImage.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  商品预览图模型 data-model

#import <Foundation/Foundation.h>

@interface SUGoodsImage : NSObject

//图片ID
@property (nonatomic, copy) NSString * imageId;
//用户ID
@property (nonatomic, copy) NSString * userId;
//图片路劲
@property (nonatomic, copy) NSString * path;
//图片地址
@property (nonatomic, copy) NSString * url;

@end
