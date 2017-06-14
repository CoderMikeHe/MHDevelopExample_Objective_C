//
//  SUGoodsFrame.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoodsFrame.h"

@interface SUGoodsFrame ()

/// 商品模型
@property (nonatomic, readwrite, strong) SUGoods *goods;

/** cellHeight */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;
/** 卖价 */
@property (nonatomic, readwrite, assign) CGRect priceLalelFrame;

/** 原价 */
@property (nonatomic, readwrite, assign) CGRect oPriceLalelFrame;

/** 运费 */
@property (nonatomic, readwrite, assign) CGRect freightageLalelFrame;
@end

@implementation SUGoodsFrame

- (instancetype)initWithGoods:(SUGoods *)goods
{
    self = [super init];
    if (self) {
        self.goods = goods;
        
        /// 计算尺寸
        CGFloat priceViewH = 38.0f;
        /// 卖价尺寸
        CGSize priceLabelSize = [goods.goodsPriceAttributedString mh_sizeWithLimitWidth:MHMainScreenWidth];
        CGFloat priceLabelX = SUGlobalViewLeftOrRightMargin;
        CGFloat priceLabelY = (priceViewH  - priceLabelSize.height);
        self.priceLalelFrame = (CGRect){{priceLabelX , priceLabelY},priceLabelSize};
        /// 运费
        CGFloat freightExplainX = CGRectGetMaxX(self.priceLalelFrame)+SUGlobalViewInnerMargin;
        CGSize freightExplainSize = [goods.freightExplain mh_sizeWithFont:MHRegularFont_12];
        CGFloat freightExplainY = (priceViewH -4 -freightExplainSize.height-6);
        /// 默认尺寸
        self.oPriceLalelFrame = CGRectZero;
        if (MHStringIsNotEmpty(goods.goodsOPriceAttributedString.string)) {
            /// 原价
            CGFloat oPriceX = CGRectGetMaxX(self.priceLalelFrame)+5.0f;;
            CGSize oPriceSize = [goods.goodsOPriceAttributedString mh_sizeWithLimitWidth:MHMainScreenWidth-SUGlobalViewInnerMargin-oPriceX];
            CGFloat oPriceY = (priceViewH - 4-oPriceSize.height) ;
            self.oPriceLalelFrame = (CGRect){{oPriceX , oPriceY},oPriceSize};
            /// 运费
            freightExplainX = CGRectGetMaxX(self.oPriceLalelFrame)+SUGlobalViewInnerMargin;
        }
        /// 运费尺寸
        self.freightageLalelFrame = (CGRect){{freightExplainX , freightExplainY} , {freightExplainSize.width + 16 , freightExplainSize.height+6}};
        
        /// 计算描述的高度
        CGFloat limitWidth = MHMainScreenWidth - 2*SUGlobalViewLeftOrRightMargin;
        /// 字体的行高
        CGFloat lineHeight = ceil(MHRegularFont_14.lineHeight);
        CGFloat descH = ([goods.goodsDescription mh_sizeWithFont:MHRegularFont_14 limitWidth:limitWidth].height>(lineHeight))?(2*lineHeight):(lineHeight);
        
        /// cellHeight+2（2容错）
        self.cellHeight = 55+88+38+33+34+14+descH+2;
    }
    
    return self;
}
@end
