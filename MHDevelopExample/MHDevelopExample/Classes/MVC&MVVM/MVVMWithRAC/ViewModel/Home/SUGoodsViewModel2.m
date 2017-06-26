//
//  SUGoodsViewModel2.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的 `商品首页的视图模型` -- VM

#import "SUGoodsViewModel2.h"
#import "SUGoodsData.h"
#import "SUBanner.h"

@interface SUGoodsViewModel2 ()
/// banners
@property (nonatomic, readwrite, copy) NSArray <NSString *> *banners;

/// 请求banner数据的命令
@property (nonatomic, readwrite, strong) RACCommand *requestBannerDataCommand;

/// banner
@property (nonatomic, readwrite, copy) NSArray <SUBanner *> *bannerModels;
/// 商品模型数组
@property (nonatomic, readwrite, copy) NSArray *goods;

/// cell 上的事件处理
/// 用户头像被点击
@property (nonatomic, readwrite, strong) RACSubject *didClickedAvatarSubject;
/// 位置被点击
@property (nonatomic, readwrite, strong) RACSubject *didClickedLocationSubject;
/// 回复按钮被点击
@property (nonatomic, readwrite, strong) RACSubject *didClickedReplySubject;
///// 点赞被点击
@property (nonatomic, readwrite, strong) RACCommand *operationCommand;
@end

@implementation SUGoodsViewModel2
#pragma mark - Ovrride
- (void)initialize
{
    [super initialize];
    
    /// 不需要再viewDidLoad后加载数据
    self.shouldRequestRemoteDataOnViewDidLoad = NO;
    
    /// 允许下拉刷新
    self.shouldPullDownToRefresh = YES;
    /// 允许上拉加载
    self.shouldPullUpToLoadMore = YES;
    
    /// 初始化请求banners的命令
    @weakify(self);
    self.requestBannerDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        @weakify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /// 请求banner数据 模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /// 获取数据
                NSData *data = [NSData dataNamed:@"SUBannerData.data"];
                /// convert to model array
                self.bannerModels = [SUBanner modelArrayWithJSON:data];
                /// banners
                self.banners = [self.bannerModels.rac_sequence map:^NSString *(SUBanner * banner) {
                    NSString *bannerUrlString = MHStringIsNotEmpty(banner.image.url)?banner.image.url:@"";
                    return bannerUrlString;
                }].array;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    /// 初始化事件处理的信号
    self.didClickedReplySubject = [RACSubject subject];
    self.didClickedAvatarSubject = [RACSubject subject];
    self.didClickedLocationSubject = [RACSubject subject];
    
    /// 点赞
    self.operationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(SUGoodsItemViewModel * itemViewModel) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /// data
                SUGoods *goods = itemViewModel.goods;
                /// update data
                goods.isLike = !goods.isLike;
                NSInteger likes = (goods.isLike)?(goods.likes.integerValue+1):(goods.likes.integerValue-1);
                goods.likes = [NSString stringWithFormat:@"%zd",likes];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    /// 允许并行执行
    self.operationCommand.allowsConcurrentExecution = YES;
}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self);
        /// config param
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:@(page) forKey:@"page"];
        /// 请求商品数据
        /// 请求商品数据 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            /// 获取数据
            NSData *data = [NSData dataNamed:[NSString stringWithFormat:@"SUGoodsData_%zd.data",(page)]];
            SUGoodsData *goodsData = [SUGoodsData modelWithJSON:data];
            /// config data
            self.page = goodsData.currentPage;
            self.lastPage = goodsData.lastPage;
            self.perPage = goodsData.perPage;
            
            NSLog(@"----已经上拉加载第%zd页----",self.page);
            /// 转化数据
            NSArray *viewModels = [goodsData.data.rac_sequence map:^SUGoodsItemViewModel *(SUGoods * goods) {
                @strongify(self);
                SUGoodsItemViewModel *itemViewModel = [[SUGoodsItemViewModel alloc] initWithGoods:goods];
                itemViewModel.didClickedLocationSubject = self.didClickedLocationSubject;
                itemViewModel.didClickedAvatarSubject = self.didClickedAvatarSubject;
                itemViewModel.didClickedReplySubject = self.didClickedReplySubject;
                itemViewModel.operationCommand = self.operationCommand;
                return itemViewModel;
            }].array;
            
            if (page==1) {
                self.dataSource = viewModels ?:@[];
            }else{
                //// 类似于拼接
                self.dataSource  = @[ (self.dataSource ?:@[]).rac_sequence , viewModels.rac_sequence].rac_sequence.flatten.array;
            }
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


#pragma mark - Public Function
/// 通过索引获取数据
- (NSString *)bannerUrlWithIndex:(NSInteger)index
{
    return [self.bannerModels[index] url];
}

@end
