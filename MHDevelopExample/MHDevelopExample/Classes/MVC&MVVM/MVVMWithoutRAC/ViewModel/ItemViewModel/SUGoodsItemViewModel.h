//
//  SUGoodsItemViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 和 MVVM With RAC的 开发模式的 `商品的视图模型` -- VM

#import <Foundation/Foundation.h>
#import "SUGoods.h"
@interface SUGoodsItemViewModel : NSObject
/// 商品模型
@property (nonatomic, readonly, strong) SUGoods *goods;

//// ------ 商品模型属性 -----

/// 商品数量
@property (nonatomic, readonly, copy) NSString *number;

/// 商品图片UrlString
@property (nonatomic, readonly, copy) NSArray <NSString *> *imagesUrlStrings;
/// 运费情况
@property (nonatomic, readonly, copy) NSString *freightExplain;

/// 发布时间描述
@property (nonatomic, readonly, copy) NSString *goodsPublishTime;

/// 商品价格的富文本
@property (nonatomic, readonly, copy) NSAttributedString *goodsPriceAttributedString;

/// 商品原价的富文本
@property (nonatomic, readonly, copy) NSAttributedString *goodsOPriceAttributedString;

/// 全新+title
@property (nonatomic, readonly, copy) NSAttributedString *goodsTitleAttributedString;


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
