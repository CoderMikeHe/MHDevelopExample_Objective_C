//
//  SUGoodsItemViewModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 和 MVVM With RAC的 开发模式的 `商品的视图模型` -- VM

#import "SUGoodsItemViewModel.h"
#import "SUGoods+SUAttributedString.h"

@interface SUGoodsItemViewModel ()

/// 商品模型
@property (nonatomic, readwrite, strong) SUGoods *goods;

/// 商品数量
@property (nonatomic, readwrite, copy) NSString *number;

/// 商品图片UrlString
@property (nonatomic, readwrite, copy) NSArray <NSString *> *imagesUrlStrings;
/// 运费情况
@property (nonatomic, readwrite, copy) NSString *freightExplain;

/// 发布时间描述
@property (nonatomic, readwrite, copy) NSString *goodsPublishTime;

/// 商品价格的富文本
@property (nonatomic, readwrite, copy) NSAttributedString *goodsPriceAttributedString;

/// 商品原价的富文本
@property (nonatomic, readwrite, copy) NSAttributedString *goodsOPriceAttributedString;

/// 全新+title
@property (nonatomic, readwrite, copy) NSAttributedString *goodsTitleAttributedString;


/** cellHeight */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;
/** 卖价 */
@property (nonatomic, readwrite, assign) CGRect priceLalelFrame;

/** 原价 */
@property (nonatomic, readwrite, assign) CGRect oPriceLalelFrame;

/** 运费 */
@property (nonatomic, readwrite, assign) CGRect freightageLalelFrame;
@end

@implementation SUGoodsItemViewModel

- (instancetype)initWithGoods:(SUGoods *)goods
{
    self = [super init];
    if (self) {
        self.goods = goods;
        
        /// 商品数量
        self.number = [NSString stringWithFormat:@"数量 %@",goods.number];
        
        /// 邮费情况
        NSString *freightExplain = nil;
        SUGoodsExpressType expressType = goods.expressType;
        if (expressType==SUGoodsExpressTypeFree) {
            // 包邮
            freightExplain = @"包邮";
        }else if(expressType == SUGoodsExpressTypeValue){
            // 指定运费
            NSString *extralFee = [NSString stringWithFormat:@"运费 ¥%@",goods.expressFee];
            freightExplain = extralFee;
        }else if (expressType == SUGoodsExpressTypeFeeding){
            freightExplain = @"运费待议";
        }
        self.freightExplain = freightExplain;
        
        /// 卖价
        self.goodsPriceAttributedString = [goods su_goodsPriceAttributedString];
        
        /// 原价
        self.goodsOPriceAttributedString = [goods su_goodsOPriceAttributedString];
        
        /// titleAttr
        self.goodsTitleAttributedString = [goods su_goodsTitleAttributedString];
        
        /// 发布时间
        self.goodsPublishTime = [goods.editAt mh_string_yyyy_MM_dd];
        
        /// 商品图片
        self.imagesUrlStrings = [self imgULRs];

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

/// 商品图片数组
- (NSArray<NSString *> *)imgULRs {
    NSMutableArray *urlStrings = [NSMutableArray array];
    [self.goods.images enumerateObjectsUsingBlock:^(SUGoodsImage *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.url) [urlStrings addObject:obj.url];
    }];
    return urlStrings.copy;
}
@end
