//
//  SUBanner.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  banner模型 -- M

#import "SUModel.h"
#import "SUGoodsImage.h"

//// 活动页跳转类型
typedef NS_ENUM(NSUInteger, SUActivityPageSkipType) {
    SUActivityPageSkipTypeWebPage = 0,       /// web
    SUActivityPageSkipTypeNativePage = 1,    /// 原生
};



@interface SUBanner : SUModel
/// 服务器数据id 主键
@property (nonatomic, readwrite, copy)   NSString *primaryKey;
/// 跳转类型
@property (nonatomic, readwrite, assign) SUActivityPageSkipType type;
/// 图片模型
@property (nonatomic, readwrite, strong) SUGoodsImage  *image;
/// 标题
@property (nonatomic, readwrite, copy)   NSString *title;
/// 描述
@property (nonatomic, readwrite, copy)   NSString *desc;
/// 点击链接
@property (nonatomic, readwrite, copy)   NSString *url;
/// bannerId
@property (nonatomic, readwrite, copy)   NSString *bannerId;
/// 展示订单
@property (nonatomic, readwrite, copy)   NSString *displayOrder;
/// 开始时间
@property (nonatomic, readwrite, copy)   NSString *startDate;
/// 结束时间
@property (nonatomic, readwrite, copy)   NSString *endDate;
/// 创建时间
@property (nonatomic, readwrite, copy)   NSString *createdAt;
/// 创建用户
@property (nonatomic, readwrite, copy)   NSString *createdUser;
/// 更行时间
@property (nonatomic, readwrite, copy)   NSString *updatedAt;
/// 更新用户
@property (nonatomic, readwrite, copy)   NSString *updatedUser;
@end
