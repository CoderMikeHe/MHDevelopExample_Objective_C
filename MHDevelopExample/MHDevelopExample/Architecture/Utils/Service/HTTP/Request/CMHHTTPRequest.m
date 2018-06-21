//
//  CMHHTTPRequest.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "CMHHTTPRequest.h"
#import "CMHHTTPService.h"

@interface CMHHTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) CMHURLParameters *urlParameters;

@end

@implementation CMHHTTPRequest

+(instancetype)requestWithParameters:(CMHURLParameters *)parameters{
    return [[self alloc] initRequestWithParameters:parameters];
}

-(instancetype)initRequestWithParameters:(CMHURLParameters *)parameters{
    
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}


@end

/// 网络服务层分类 方便CMHHTTPRequest 主动发起请求
@implementation CMHHTTPRequest (CMHHTTPService)
///// 请求数据
-(NSURLSessionDataTask *)enqueueResultClass:(Class /*subclass of CMHObject*/) resultClass
                               parsedResult:(BOOL)parsedResult
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    return [[CMHHTTPService sharedInstance] enqueueRequest:self
                                               resultClass:resultClass
                                              parsedResult:parsedResult
                                                   success:success
                                                   failure:failure];
}
@end

