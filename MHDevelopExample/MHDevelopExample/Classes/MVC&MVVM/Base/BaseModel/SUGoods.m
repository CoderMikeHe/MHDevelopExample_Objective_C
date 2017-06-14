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







//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
- (NSArray<NSString *> *)imagesUrlStrings
{
    NSMutableArray *urlStrings = [NSMutableArray array];
    [self.images enumerateObjectsUsingBlock:^(SUGoodsImage *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.url) [urlStrings addObject:obj.url];
    }];
    return urlStrings.copy;
}

- (NSString *)freightExplain
{
    NSString *freightExplain = nil;
    SUGoodsExpressType expressType = self.expressType;
    if (expressType==SUGoodsExpressTypeFree) {
        // 包邮
        freightExplain = @"包邮";
    }else if(expressType == SUGoodsExpressTypeValue){
        // 指定运费
        NSString *extralFee = [NSString stringWithFormat:@"运费 ¥%@",self.expressFee];
        freightExplain = extralFee;
    }else if (expressType == SUGoodsExpressTypeFeeding){
        freightExplain = @"运费待议";
    }
    return freightExplain;
}

- (NSString *)goodsPublishTime
{
    return [self.editAt mh_string_yyyy_MM_dd];
}

- (NSAttributedString *)goodsPriceAttributedString
{
    if(!MHStringIsNotEmpty(self.price)) return nil;
    
    if (self.price.floatValue<=.000001f) return nil;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", self.price]];
    
    /// 设置所有字符串的富文本
    [attrString setAttributes:@{NSForegroundColorAttributeName:SUGlobalLightRedColor,
                                NSFontAttributeName:MHMediumFont(22.0f)
                                } range:NSMakeRange(0, attrString.string.length)];
    // 设置第一个￥的字体大小
    NSRange rmbRange = NSMakeRange(0, 1);
    [attrString yy_setFont:MHMediumFont(14.0f) range:rmbRange];
    [attrString yy_setColor:SUGlobalLightRedColor range:rmbRange];
    
    return attrString.copy;
}

- (NSAttributedString *)goodsOPriceAttributedString
{
    if(MHStringIsNotEmpty(self.oPrice) && self.oPrice.floatValue>.0000001)
    {
        NSMutableAttributedString *oPriceAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价%@",self.oPrice]];
        oPriceAttr.yy_font = MHRegularFont_12;
        oPriceAttr.yy_color = SUGlobalShadowGrayTextColor;
        return oPriceAttr.copy;
    }
    return nil;
}

- (NSAttributedString *)goodsTitleAttributedString
{
    // 是否全新
    NSString *goodsTitle = [self valueForKeyPath:@"title"];
    if (!MHStringIsNotEmpty(goodsTitle) && !self.isBrandNew) return nil;
    
    NSString *tempStr = (self.isBrandNew)?[NSString stringWithFormat:@" %@",goodsTitle]:goodsTitle;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    attr.yy_font = MHMediumFont(15.0f);
    attr.yy_color = MHGlobalShadowBlackTextColor;
    
    if (self.isBrandNew) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"su_goods_home_new"];
        attach.bounds = CGRectMake(0, -2.5, attach.image.size.width, attach.image.size.height);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
        [attr insertAttributedString:imageAttr atIndex:0];
        return attr;
    }
    return attr;

}
//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore

@end
