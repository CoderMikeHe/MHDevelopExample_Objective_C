//
//  CMHHTTPRequest.h
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  网络服务层 - 请求

#import <Foundation/Foundation.h>
#import "CMHURLParameters.h"
#import "CMHHTTPResponse.h"
#import <AFNetworking/AFNetworking.h>
@interface CMHHTTPRequest : NSObject
/// 请求参数
@property (nonatomic, readonly, strong) CMHURLParameters *urlParameters;
/**
 获取请求类
 @param params  参数模型
 @return 请求类
 */
+(instancetype)requestWithParameters:(CMHURLParameters *)parameters;
-(instancetype)initRequestWithParameters:(CMHURLParameters *)parameters;

@end

/// CMHHTTPService的分类
@interface CMHHTTPRequest (CMHHTTPService)

-(NSURLSessionDataTask *)enqueueResultClass:(Class /*subclass of CMHObject*/) resultClass
                               parsedResult:(BOOL)parsedResult
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end
