//
//  CMHHTTPResponse.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHHTTPResponse.h"

@interface CMHHTTPResponse ()
/// The parsed MHObject object corresponding to the API response.
/// The developer need care this data
@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码
@property (nonatomic, readwrite, assign) CMHHTTPResponseCode code;
/// 自己服务器返回的信息
@property (nonatomic, readwrite, copy) NSString *msg;
@end

@implementation CMHHTTPResponse

- (instancetype)initWithResponseObject:(NSDictionary *)responseObject parsedResult:(id)parsedResult
{
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult;
        self.code = [responseObject[CMHHTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[CMHHTTPServiceResponseMsgKey];
    }
    return self;
}
@end
