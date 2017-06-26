//
//  SUGoodsViewModel1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的 `商品首页的视图模型` -- VM

#import "SUGoodsViewModel1.h"
#import "SUGoodsData.h"
#import "SUBanner.h"

@interface SUGoodsViewModel1 ()
/// banners
@property (nonatomic, readwrite, copy) NSArray <NSString *> *banners;
/// banner
@property (nonatomic, readwrite, copy) NSArray <SUBanner *> *bannerModels;
@end

@implementation SUGoodsViewModel1

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
    }
    return self;
}

- (void)loadBannerData:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    /// 请求banner数据 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 获取数据
        NSData *data = [NSData dataNamed:@"SUBannerData.data"];
        /// convert to model array
        self.bannerModels = [SUBanner modelArrayWithJSON:data];
        /// banners
        self.banners = [self _bannerImageUrlStringsWithBanners:self.bannerModels];
        !success?:success(nil);
    });
}
//// 加载数据
- (void)loadData:(void (^)(id))success failure:(void (^)(NSError *))failure configFooter:(void (^)(BOOL))configFooter
{
    /// config param
    NSInteger page = self.isPullDown?1:(self.page+1);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(page) forKey:@"page"];
    
    /// 请求商品数据
    /// 请求商品数据 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (page==1) [self.dataSource removeAllObjects];
        /// 获取数据
        NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"SUGoodsData_%zd.data",(page)]];
        SUGoodsData *goodsData = [SUGoodsData modelWithJSON:data];
        /// 转化数据
        NSArray *dataSource = [self _viewModelsWithGoodsData:goodsData];
        /// 添加数据
        [self.dataSource addObjectsFromArray:dataSource];
        
        /// 回调数据
        !configFooter?:configFooter(self.page>=2);
        !success?:success(nil);
        
    });
}

- (void)thumbGoodsWithGoodsItemViewModel:(SUGoodsItemViewModel *)viewModel success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    /// 模拟网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// data
        SUGoods *goods = viewModel.goods;
        /// update data
        goods.isLike = !goods.isLike;
        NSInteger likes = (goods.isLike)?(goods.likes.integerValue+1):(goods.likes.integerValue-1);
        goods.likes = [NSString stringWithFormat:@"%zd",likes];
        !success?:success(@(goods.isLike));
    });
}



/// 通过索引获取数据
- (NSString *)bannerUrlWithIndex:(NSInteger)index
{
    return [self.bannerModels[index] url];
}


#pragma mark - 辅助方法
//// banner data
- (NSArray *)_bannerImageUrlStringsWithBanners:(NSArray *)banners
{
    NSMutableArray *bannerImageUrlString = [NSMutableArray arrayWithCapacity:banners.count];
    
    [banners enumerateObjectsUsingBlock:^(SUBanner * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (MHStringIsNotEmpty(obj.image.url)) {
            [bannerImageUrlString addObject:obj.image.url];
        } else {
            [bannerImageUrlString addObject:@""];
        }
    }];
    return bannerImageUrlString.copy;
}

/// 处理goodsData
- (NSArray *)_viewModelsWithGoodsData:(SUGoodsData *)goodsData
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:goodsData.data.count];
    
    for (SUGoods *goods in goodsData.data) {
        SUGoodsItemViewModel *itemViewModel = [[SUGoodsItemViewModel alloc] initWithGoods:goods];
        [viewModels addObject:itemViewModel];
    }
    /// config data
    self.page = goodsData.currentPage;
    self.lastPage = goodsData.lastPage;
    self.perPage = goodsData.perPage;
    
    NSLog(@"----已经上拉加载第%zd页----",self.page);
    
    return viewModels.copy;
}
@end
