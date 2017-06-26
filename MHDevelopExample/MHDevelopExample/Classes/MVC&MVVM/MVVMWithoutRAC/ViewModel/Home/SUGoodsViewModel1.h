//
//  SUGoodsViewModel1.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的 `商品首页的视图模型` -- VM

#import "SUTableViewModel1.h"
#import "SUGoodsItemViewModel.h"

@interface SUGoodsViewModel1 : SUTableViewModel1

/// banners
@property (nonatomic, readonly, copy) NSArray <NSString *> *banners;
/// load banners data
- (void)loadBannerData:(void (^)(id responseObject))success
               failure:(void (^)(NSError *))failure;

/// 点赞商品
- (void)thumbGoodsWithGoodsItemViewModel:(SUGoodsItemViewModel *)viewModel
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *))failure;

/// 通过索引获取数据
- (NSString *)bannerUrlWithIndex:(NSInteger)index;
@end
