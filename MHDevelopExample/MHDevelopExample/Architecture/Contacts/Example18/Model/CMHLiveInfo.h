//
//  CMHLiveInfo.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/21.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"
#import "CMHLiveRoom.h"
@interface CMHLiveInfo : CMHObject

/// 直播间列表
@property (nonatomic, readwrite, copy) NSArray <CMHLiveRoom *> *list;

/// 总页数
@property (nonatomic, readwrite, assign) NSInteger totalPage;

/// 是否同城
@property (nonatomic, readwrite, assign) BOOL samecity;

/// hotConfig
@property (nonatomic, readwrite, assign) NSInteger hotConfig;

/// hotswitch
@property (nonatomic, readwrite, assign) id hotswitch;

/// hotswitch2
@property (nonatomic, readwrite, copy) NSArray *hotswitch2;
@end
