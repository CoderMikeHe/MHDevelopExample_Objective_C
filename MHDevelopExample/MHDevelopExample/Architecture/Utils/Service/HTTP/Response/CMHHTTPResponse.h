//
//  CMHHTTPResponse.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"
#import "CMHHTTPServiceConstant.h"
/// 请求数据返回的状态码
typedef NS_ENUM(NSUInteger, CMHHTTPResponseCode) {
    CMHHTTPResponseCodeSuccess  = 100 ,                     /// 请求成功    (PS：根据自身项目去设置)
    CMHHTTPResponseCodeNotLogin = 402 ,                     /// 用户尚未登录,或者Token失效 (PS：根据自身项目去设置)
};
@interface CMHHTTPResponse : CMHObject

/// The parsed MHObject object corresponding to the API response.
/// The developer need care this data
@property (nonatomic, readonly, strong) id parsedResult;
/// 自己服务器返回的状态码 对应于服务器json数据的 code
@property (nonatomic, readonly, assign) CMHHTTPResponseCode code;
/// 自己服务器返回的信息 对应于服务器json数据的 msg
@property (nonatomic, readonly, copy) NSString *msg;


// Initializes the receiver with the headers from the given response, and given the origin data and the
// given parsed model object(s).
- (instancetype)initWithResponseObject:(NSDictionary *)responseObject parsedResult:(id)parsedResult;
@end
