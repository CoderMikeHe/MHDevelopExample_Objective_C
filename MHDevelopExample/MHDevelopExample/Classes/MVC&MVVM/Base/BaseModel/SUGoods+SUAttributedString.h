//
//  SUGoods+SUAttributedString.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoods.h"

@interface SUGoods (SUAttributedString)

/**
 * 商品价格的富文本
 */
- (NSMutableAttributedString *)su_goodsPriceAttributedString;

/**
 * 商品原价格的富文本
 */
- (NSMutableAttributedString *)su_goodsOPriceAttributedString;

/** 
 * 全新+标题 
 */
- (NSMutableAttributedString *)su_goodsTitleAttributedString;

@end
