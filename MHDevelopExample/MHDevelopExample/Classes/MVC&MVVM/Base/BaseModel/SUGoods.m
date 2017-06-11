//
//  SUGoods.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoods.h"

@implementation SUGoods
/// 属性map
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"goodsId":@[@"id", @"goodsId", @"goods_id"],
             @"goodsDescription":@"description",
             @"oPrice":@"oprice",
             @"brandNew":@"isNew"
             };
}
/// 属性名 生成 class
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"images":[SUGoodsImage class]};
}
@end
