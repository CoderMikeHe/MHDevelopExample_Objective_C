//
//  SUGoodsFrame.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  商品frame模型 -- 由于可能也需要手动布局计算尺寸 所引申出来的一个模型 （PS：如果遇到比较复杂的cell，这个是笔者用MVC开发的一贯作风，会创建一个计算尺寸的modelFrame，但他的职责比较单一，就是计算cell里面子控件的frame。但是这个可能也会认为是 viewModel。如果这样来说，笔者可能是误打误撞了。可能大家的一贯的作风：是在model里面计算cell的高度。其实都一样，其实并不难）

#import <Foundation/Foundation.h>
#import "SUGoods.h"
@interface SUGoodsFrame : NSObject

/// 商品模型
@property (nonatomic, readonly, strong) SUGoods *goods;

//// ------ 商品尺寸属性 -----
/** cellHeight */
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/** 卖价Frame */
@property (nonatomic, readonly , assign) CGRect priceLalelFrame;

/** 原价Frame */
@property (nonatomic, readonly , assign) CGRect oPriceLalelFrame;

/** 运费Frame */
@property (nonatomic, readonly , assign) CGRect freightageLalelFrame;

/// 初始化
- (instancetype)initWithGoods:(SUGoods *)goods;
@end
