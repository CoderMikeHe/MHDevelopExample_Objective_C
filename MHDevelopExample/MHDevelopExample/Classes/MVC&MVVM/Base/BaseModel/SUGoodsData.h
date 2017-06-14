//
//  SUGoodsData.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  获取的商品数据 -- M

#import "SUModel.h"
#import "SUGoods.h"
@interface SUGoodsData : SUModel

@property (nonatomic, readwrite, assign) NSInteger total;
@property (nonatomic, readwrite, assign) NSInteger perPage;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, readwrite, assign) NSInteger lastPage;
@property (nonatomic, readwrite, assign) NSInteger from;
@property (nonatomic, readwrite, assign) NSInteger to;

/// 装着SUGoods数据
@property (nonatomic, readwrite, copy) NSArray<SUGoods *> * data;

@end
