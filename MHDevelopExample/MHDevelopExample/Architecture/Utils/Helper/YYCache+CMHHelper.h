//
//  YYCache+CMHHelper.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <YYCache/YYCache.h>

/// 地图首页搜索历史 获取缓存的key
FOUNDATION_EXTERN NSString * _Nullable const CMHSearchFarmsHistoryCacheKey;

/// 第六个Demo中缓存网络图片 获取缓存的key
FOUNDATION_EXTERN NSString * _Nullable const CMHExample06RemoteImageCacheKey;


@interface YYCache (CMHHelper)
/// 单例
+ (instancetype _Nullable )sharedCache;
@end
