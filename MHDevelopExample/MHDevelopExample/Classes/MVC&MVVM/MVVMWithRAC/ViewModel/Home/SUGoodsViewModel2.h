//
//  SUGoodsViewModel2.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的 `商品首页的视图模型` -- VM

#import "SUTableViewModel2.h"
#import "SUGoodsItemViewModel.h"

@interface SUGoodsViewModel2 : SUTableViewModel2

/// banners
@property (nonatomic, readonly, copy) NSArray <NSString *> *banners;

/// 请求banner数据的命令
@property (nonatomic, readonly, strong) RACCommand *requestBannerDataCommand;


/// 通过索引获取数据
- (NSString *)bannerUrlWithIndex:(NSInteger)index;



/// cell 上的事件处理
/// 用户头像被点击
@property (nonatomic, readonly, strong) RACSubject *didClickedAvatarSubject;
/// 位置被点击
@property (nonatomic, readonly, strong) RACSubject *didClickedLocationSubject;
/// 回复按钮被点击
@property (nonatomic, readonly, strong) RACSubject *didClickedReplySubject;
@end
