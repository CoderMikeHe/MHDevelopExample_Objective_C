//
//  CMHURLConfigure.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/21.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#ifndef CMHURLConfigure_h
#define CMHURLConfigure_h

/// 以下接口都抓的是 喵live

/// 获取直播间列表
#define CMH_GET_LIVE_ROOM_LIST  @"Room/GetHotLive_v2"

/// 获取最热们的主播
#define CMH_GET_HOT_REC_ANCHOR  @"Room/GetHotRecAnchor"

/// 获取滚动图 <PS : https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1 >
/// <PS: 这个接口主要用于文件上传测试模拟网络场景 ： 1、获取文件ID  2、分片上传 3、检测文件片合成 4、删除文件片>
#define CMH_GET_HOT_TAB  @"Room/GetHotTab"

#endif /* CMHURLConfigure_h */
