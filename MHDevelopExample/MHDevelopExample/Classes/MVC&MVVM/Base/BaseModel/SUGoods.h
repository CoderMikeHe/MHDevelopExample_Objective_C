//
//  SUGoods.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  首页商品模型 data-model -- M

#import <Foundation/Foundation.h>
#import "SUGoodsImage.h"
#import "SUModel.h"
/** 商品运费类型 */
typedef NS_ENUM(NSUInteger, SUGoodsExpressType) {
    SUGoodsExpressTypeFree = 0,   // 包邮
    SUGoodsExpressTypeValue = 1,  // 运费
    SUGoodsExpressTypeFeeding = 2,// 待议
};

@interface SUGoods : SUModel
/// === 商品相关 ===
/// 商品ID
@property (nonatomic, readwrite, copy) NSString * goodsId;
/// 位置
@property (nonatomic, readwrite, copy) NSString * locationAreaName;
/// 商品名称
@property (nonatomic, readwrite, copy) NSString *title;
/// 商品描述
@property (nonatomic, readwrite, copy) NSString * goodsDescription;
/// 商品价格
@property (nonatomic, readwrite, copy) NSString * price;
/// 商品原价格
@property (nonatomic, readwrite, copy) NSString * oPrice;
/// 浏览次数
@property (nonatomic, readwrite, copy) NSString * hits;
/// 喜欢次数
@property (nonatomic, readwrite, copy) NSString * likes;
/// 留言数量
@property (nonatomic, readwrite, copy) NSString * messages;
/// 商品数量
@property (nonatomic, readwrite, copy) NSString * number;
/// 运费类型： 0 包邮  1 指定运费  2待议
@property (nonatomic, readwrite, assign) SUGoodsExpressType expressType;
/// 运费
@property (nonatomic, readwrite, copy) NSString * expressFee;
/// 更新时间
@property (nonatomic, strong) NSDate * updatedAt;
/// 发布（重新发布）时间
@property (nonatomic, strong) NSDate * editAt;
/// 是否已经收藏
@property (nonatomic, assign) BOOL isLike;
/// 商品预览图片模型列表
@property (nonatomic, readwrite, copy) NSArray <SUGoodsImage *> * images;
/// 是否全新
@property (nonatomic, readwrite, assign , getter = isBrandNew) BOOL brandNew;
/// 活动价
@property (nonatomic, readwrite, copy) NSString *activityPrice;

/// === 商品中的用户相关的信息 ===
/// 用户ID
@property (nonatomic, readwrite, copy) NSString * userId;
/// 用户头像
@property (nonatomic, readwrite, copy) NSString * avatar;
/// 用户昵称
@property (nonatomic, readwrite, copy) NSString * nickName;
/// 是否芝麻认证
@property (nonatomic, readwrite, assign) BOOL iszm;








//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
//// 辅助属性
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

//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore
@end
