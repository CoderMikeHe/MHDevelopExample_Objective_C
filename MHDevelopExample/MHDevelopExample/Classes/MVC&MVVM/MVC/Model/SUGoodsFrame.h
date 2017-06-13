//
//  SUGoodsFrame.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  商品frame模型 -- 由于可能也需要手动布局计算尺寸 所引申出来的一个模型

#import <Foundation/Foundation.h>
#import "SUGoods.h"
@interface SUGoodsFrame : NSObject

/// 商品模型
@property (nonatomic, readwrite, strong) SUGoods *goods;

/// cellHeight
@property (nonatomic, readwrite, assign) CGFloat cellHeight;


@end
