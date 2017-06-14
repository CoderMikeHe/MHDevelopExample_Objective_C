//
//  SUGoodsImage.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  商品预览图模型 data-model  -- M

#import "SUModel.h"

@interface SUGoodsImage : SUModel

//图片ID
@property (nonatomic, readwrite, copy) NSString * imageId;
//用户ID
@property (nonatomic, readwrite, copy) NSString * userId;
//图片路劲
@property (nonatomic, readwrite, copy) NSString * path;
//图片地址
@property (nonatomic, readwrite, copy) NSString * url;

//缩略图地址
@property (nonatomic, readwrite, copy) NSString * middle;
@property (nonatomic, readwrite, copy) NSString * small;


@end
