//
//  MHHorizontalGroup.h
//  MHObjectiveC
//
//  Created by CoderMikeHe on 2018/12/14.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  组

#import <Foundation/Foundation.h>
#import "MHHorizontal.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontalGroup : NSObject

/// idstr
@property (nonatomic, readwrite, copy) NSString *idstr;

/// Name
@property (nonatomic, readwrite, copy) NSString *name;

/// 数据列表
@property (nonatomic, readwrite, copy) NSArray<MHHorizontal *> *horizontals;


/// 配置测试数据
+ (NSArray <MHHorizontalGroup *>*)fetchHorizontalGroups;




/// 辅助属性 这个两个属性只用于 Mode_2，切记
/// 当前页
@property (nonatomic, readwrite, assign) NSInteger currentPage;
/// 总页数
@property (nonatomic, readwrite, assign) NSInteger numberOfPages;
@end
NS_ASSUME_NONNULL_END
