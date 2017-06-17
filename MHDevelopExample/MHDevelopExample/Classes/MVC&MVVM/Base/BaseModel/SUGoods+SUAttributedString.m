//
//  SUGoods+SUAttributedString.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoods+SUAttributedString.h"

@implementation SUGoods (SUAttributedString)
/**
 * 商品价格的富文本
 */
- (NSMutableAttributedString *)su_goodsPriceAttributedString{
    
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

/**
 * 商品原价格的富文本
 */
- (NSMutableAttributedString *)su_goodsOPriceAttributedString{
    if(MHStringIsNotEmpty(self.oPrice) && self.oPrice.floatValue>.0000001)
    {
        NSMutableAttributedString *oPriceAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"原价%@",self.oPrice]];
        oPriceAttr.yy_font = MHRegularFont_12;
        oPriceAttr.yy_color = SUGlobalShadowGrayTextColor;
        return oPriceAttr.copy;
    }
    return nil;
}

/**
 * 全新+标题
 */
- (NSMutableAttributedString *)su_goodsTitleAttributedString{
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
@end
