//
//  CMHConstEnum.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#ifndef CMHConstEnum_h
#define CMHConstEnum_h

/// tababr item tag
typedef NS_ENUM(NSUInteger, CMHTabBarItemTagType) {
    CMHTabBarItemTagTypeMainFrame = 0,    /// 消息回话
    CMHTabBarItemTagTypeContacts,         /// 通讯录
    CMHTabBarItemTagTypeDiscover,         /// 发现
    CMHTabBarItemTagTypeProfile,          /// 我的
};


typedef NS_ENUM(NSUInteger, MHSwitchToRootType) {
    MHSwitchToRootTypeDefault = 0,        /// 默认
    MHSwitchToRootTypeModule,             /// 常用开发模块
    MHSwitchToRootTypeArchitecture,       /// mvc基本架构
};

#endif /* CMHConstEnum_h */
