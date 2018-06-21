//
//  CMHHTTPServiceConstant.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#ifndef CMHHTTPServiceConstant_h
#define CMHHTTPServiceConstant_h

/// 服务器相关
#define CMHHTTPRequestTokenKey @"token"

/// 私钥key
#define CMHHTTPServiceKey      @"privatekey"
/// 私钥Value
#define CMHHTTPServiceKeyValue @"/** 你的私钥 **/"

/// 签名key
#define CMHHTTPServiceSignKey  @"sign"

/// 服务器返回的三个固定字段 根据你后台返回定制
/// 状态码key
#define CMHHTTPServiceResponseCodeKey       @"code"
/// 消息key
#define CMHHTTPServiceResponseMsgKey        @"msg"
/// 数据data
#define CMHHTTPServiceResponseDataKey       @"data"
/// 数据data{"list":[]}
#define CMHHTTPServiceResponseDataListKey   @"list"

#endif /* CMHHTTPServiceConstant_h */
