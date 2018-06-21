//
//  CMHHTTPService.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHHTTPService.h"



/// The Http request error domain
NSString *const CMHHTTPServiceErrorDomain = @"CMHHTTPServiceErrorDomain";

/// 连接服务器失败 default
NSInteger const CMHHTTPServiceErrorConnectionFailed = 668;
NSInteger const CMHHTTPServiceErrorJSONParsingFailed = 669;
NSInteger const CMHHTTPServiceErrorBadRequest = 670;
NSInteger const CMHHTTPServiceErrorRequestForbidden = 671;
/// 服务器请求失败
NSInteger const CMHHTTPServiceErrorServiceRequestFailed = 672;
///
NSInteger const CMHHTTPServiceErrorSecureConnectionFailed = 673;

/// URL key
NSString * const CMHHTTPServiceErrorRequestURLKey = @"CMHHTTPServiceErrorRequestURLKey";
/// HttpStatusCode key
NSString * const CMHHTTPServiceErrorHTTPStatusCodeKey = @"CMHHTTPServiceErrorHTTPStatusCodeKey";
/// error desc key
NSString * const CMHHTTPServiceErrorDescriptionKey = @"CMHHTTPServiceErrorDescriptionKey";

@protocol CMHHTTPServiceProxy <NSObject>
/**
 https://www.jianshu.com/p/f93147740bf2
 `Protocol` 既可以写在头文件中，也可以写在实现文件的类扩展中。
 
 前者：可以当做是给这个类添加了一些外部接口。
 后者：可以当做是给这个类添加了一些私有接口。
 
 写在头文件中，类内部自然能通过self调用，外部也可以调用里面的方法，子类可以实现或者重写里面的方法。
 而在类扩展中，内部可以调用，外部不能调用、子类不能重写实现和重写，相当于是私有方法。
 不过，如果子类自身又遵循了这个协议，但并没有实现，那么在运行时，系统会一级级往上查找，直到找到父类的方法实现。也就是说，只要知道苹果的私有方法名，并且确保自己的类是这个私有方法所属类的子类，就可以在子类中通过只声明不实现的方式执行父类中该私有方法的实现。
 
 */
@optional
/// AFN 内部的数据访问方法
///
/// @param method           HTTP 方法
/// @param URLString        URLString
/// @param parameters       请求参数字典
/// @param uploadProgress   上传进度
/// @param downloadProgress 下载进度
/// @param success          成功回调
/// @param failure          失败回调
///
/// @return NSURLSessionDataTask，需要 resume
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end





@interface CMHHTTPService ()<CMHHTTPServiceProxy>
@end


@implementation CMHHTTPService
static id service_ = nil;
#pragma mark -  HTTPService
+(instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://live.9158.com/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return service_;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [super allocWithZone:zone];
    });
    return service_;
}
- (id)copyWithZone:(NSZone *)zone {
    return service_;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        /// 配置
        [self _configHTTPService];
    }
    return self;
}

/// config service
- (void)_configHTTPService{
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if DEBUG
    responseSerializer.removesKeysWithNullValues = NO;
#else
    responseSerializer.removesKeysWithNullValues = YES;
#endif
    responseSerializer.readingOptions = NSJSONReadingAllowFragments;
    /// config
    self.responseSerializer = responseSerializer;
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /// 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    
    self.securityPolicy = securityPolicy;
    /// 支持解析
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                      @"text/json",
                                                      @"text/javascript",
                                                      @"text/html",
                                                      @"text/plain",
                                                      @"text/html; charset=UTF-8",
                                                      nil];
    
    /// 开启网络监测
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            NSLog(@"xxxxxxxxxx 未知网络 xxxxxxxxxxx");
        }else if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"++++++++++ 无网络 ++++++++++");
        }else{
            NSLog(@"++++++++++ 有网络 ++++++++++");
        }
    }];
    [self.reachabilityManager startMonitoring];
}

#pragma mark - Request API
-(NSURLSessionDataTask *)enqueueRequest:(CMHHTTPRequest *) request
                            resultClass:(Class /*subclass of CMHObject*/) resultClass
                           parsedResult:(BOOL)parsedResult
                                success:(nullable void (^)(NSURLSessionDataTask *, id _Nullable))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure{
    return [self _enqueueRequestWithPath:request.urlParameters.path
                              parameters:request.urlParameters.parameters
                                  method:request.urlParameters.method
                             resultClass:resultClass
                            parsedResult:parsedResult
                                 success:success
                                 failure:failure];
}

/// 私有
/// 请求数据
- (NSURLSessionDataTask *)_enqueueRequestWithPath:(NSString *)path
                                       parameters:(id)parameters
                                           method:(NSString *)method
                                      resultClass:(Class /*subclass of CMHObject*/) resultClass
                                     parsedResult:(BOOL)parsedResult
                                          success:(nullable void (^)(NSURLSessionDataTask *, id _Nullable))success
                                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure{
    
    /// 成功解析
    @weakify(self);
    void (^successParse)(NSURLSessionDataTask *, id _Nullable) = ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        @strongify(self);
        /// 解析成功或失败的数据
        [self _parsedResponseOfClass:resultClass
                            fromJSON:responseObject
                          parameters:parameters
                        parsedResult:parsedResult
                                task:task
                             success:success
                             failure:failure];
    };
    
    /// 失败解析
    void (^failureParse)(NSURLSessionDataTask *_Nullable, NSError *) = ^(NSURLSessionDataTask * _Nullable task,  NSError *error){
        @strongify(self);
        
    };
    
    /// 请求数据
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:method
                                                        URLString:path
                                                       parameters:parameters
                                                   uploadProgress:nil
                                                 downloadProgress:nil
                                                          success:successParse
                                                          failure:failureParse];
    /// 必须resume
    [dataTask resume];
    
    return dataTask;
}





#pragma mark -  Parsing
- (void) _parsedResponseOfClass:(Class /*subclass of CMHObject*/ )resultClass
                       fromJSON:(NSDictionary *)responseObject
                     parameters:(id)parameters
                   parsedResult:(BOOL)parsedResult 
                           task:(NSURLSessionDataTask *)task
                        success:(nullable void (^)(NSURLSessionDataTask *, id _Nullable))success
                        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure{
    
    /////// 断言服务器返回的responseObject 必须是字典
    NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
    
    /// 在这里判断数据是否正确
    /// 判断code
    NSInteger statusCode = [responseObject[CMHHTTPServiceResponseCodeKey] integerValue];
    
    if (statusCode == CMHHTTPResponseCodeSuccess) { /// 请求成功
        
        /// 打印成功的信息
        [self _HTTPRequestLog:task body:parameters error:nil];
        
        /// 断言：resultClass可以为nil ，或者是CMHObject的子类
        NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:CMHObject.class]));
        
        /// 这里主要解析的是responseObject, data:对应的数据
        NSDictionary * responseData = responseObject[CMHHTTPServiceResponseDataKey];
        
        /// 解析字典
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            
            if (resultClass == nil) {
                /// resultClass == nil 直接把服务器的数据甩回去
                /// 1. 先生成CMHHTTPResponse对象
                CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:JSONDictionary];
                /// 2. 回调数据，根据parsedResult 来回调数据
                !success ? : success(task, parsedResult?JSONDictionary:parsedResponse);
                
                return;
            }

            /// 这里继续取出数据 data{"list":[]} ，注意这个"list"是跟后台约定死的，
            NSArray * JSONArray = JSONDictionary[CMHHTTPServiceResponseDataListKey];
            
            if ([JSONArray isKindOfClass:[NSArray class]]) {
                /// 数组保证数组里面装的是同一种类型的NSDcitionary
                for (NSDictionary *dict in JSONArray) {
                    /// 如果数组里面解析的数据不是字典 则回调错误信息
                    if (![dict isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), dict];
                        /// 回调错误信息
                        !failure ? : failure(task, [self _parsingErrorWithFailureReason:failureReason]);
                        return;
                    }
                }
                
                /// 0. 字典数组 转对应的模型
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:JSONArray];
                /// 1. 先生成CMHHTTPResponse对象
                CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedObjects];
                /// 2. 回调数据，根据parsedResult 来回调数据
                !success ? : success(task, parsedResult?parsedObjects:parsedResponse);

            }else{
                
                /// 字典转模型
                CMHObject *parsedObject = [resultClass yy_modelWithDictionary:JSONDictionary];
                /// 1. 先生成CMHHTTPResponse对象
                CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedObject];
                /// 2. 回调数据，根据parsedResult 来回调数据
                !success ? : success(task, parsedResult?parsedObject:parsedResponse);
            }
        };
        
        /// 验证一下 responseData 的类型
        if ([responseData isKindOfClass:NSArray.class]) {  /// 数组
            
            if (resultClass == nil) {
                /// resultClass == nil 直接把服务器的数据甩回去
                /// 1. 先生成CMHHTTPResponse对象
                CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseData];
                /// 2. 回调数据，根据parsedResult 来回调数据
                !success ? : success(task, parsedResult?responseData:parsedResponse);
                
            }else{
                /// 数组保证数组里面装的是同一种类型的NSDcitionary
                for (NSDictionary *JSONDictionary in responseData) {
                    
                    /// 如果数组里面解析的数据不是字典 则回调错误信息
                    if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                        /// 回调错误信息
                        !failure ? : failure(task, [self _parsingErrorWithFailureReason:failureReason]);
                        
                        return;
                    }
                }
                /// 0. 字典数组转对应的模型数组
                NSArray *parsedObjects = [NSArray yy_modelArrayWithClass:resultClass.class json:responseData];
                /// 1. 先生成CMHHTTPResponse对象
                CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedObjects];
                /// 2. 回调数据，根据parsedResult 来回调数据
                !success ? : success(task, parsedResult?parsedObjects:parsedResponse);
            }
        } else if ([responseData isKindOfClass:NSDictionary.class]) { /// 地点
            /// 解析字典
            parseJSONDictionary(responseData);
            
        } else if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
            /// 1. 先生成CMHHTTPResponse对象
            CMHHTTPResponse *parsedResponse = [[CMHHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:nil];
            /// 2. 回调数据，根据parsedResult 来回调数据
            !success ? : success(task, parsedResult?nil:parsedResponse);
        } else {
            
            /// 不是一个标准的 Json
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseData class], responseData];
            
            /// 回调错误信息
            !failure ? : failure(task, [self _parsingErrorWithFailureReason:failureReason]);
        }
    }else if(statusCode == CMHHTTPResponseCodeNotLogin ){
        NSLog(@"+++++ 用户尚未登录或Token失效 ++++")
    }else{
        /// 服务器出错
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        userInfo[CMHHTTPServiceErrorHTTPStatusCodeKey] = @(statusCode);
        
        NSString *msgTips = responseObject[CMHHTTPServiceResponseMsgKey];
        msgTips = MHStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)~",msgTips,statusCode]:[NSString stringWithFormat:@"呜呜，服务器崩溃了哟(%zd)~",statusCode];
        userInfo[CMHHTTPServiceErrorDescriptionKey] = msgTips;
        
        if (task.currentRequest.URL != nil) userInfo[CMHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
        if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
        
        NSError *requestError = [NSError errorWithDomain:CMHHTTPServiceErrorDomain code:statusCode userInfo:userInfo];
        
        /// log the error info
        [self _HTTPRequestLog:task body:parameters error:requestError];
    }
}

/// 请求错误解析
- (void)_parsedErrorWithTask:(NSURLSessionDataTask *)task
                       error:(NSError *)error
                  parameters:(id)parameters
                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure{
    
    /// 不一定有值，则HttpCode = 0;
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)task.response;
    NSInteger HTTPCode = httpResponse.statusCode;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is CMHHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = CMHHTTPServiceErrorConnectionFailed;
    NSString *errorDesc = [NSString stringWithFormat:@"呜呜，服务器崩溃了哟(%zd)~",errorCode];
    
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600

    switch (HTTPCode) {
        case 400:
            errorCode = CMHHTTPServiceErrorBadRequest;           /// 请求失败
            break;
        case 403:
            errorCode = CMHHTTPServiceErrorRequestForbidden;     /// 服务器拒绝请求
            break;
        case 422:
            errorCode = CMHHTTPServiceErrorServiceRequestFailed; /// 请求出错
            break;
        default:{
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
                errorDesc = [NSString stringWithFormat:@"呜呜，服务器崩溃了哟(%zd)~",error.code];                   /// 调试模式
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:{
                        errorCode = CMHHTTPServiceErrorSecureConnectionFailed; /// 建立安全连接出错了
                        errorDesc = [NSString stringWithFormat:@"呜呜，服务器建立安全连接出错了(%zd)~",CMHHTTPServiceErrorSecureConnectionFailed];
                        break;
                    }
                    case NSURLErrorTimedOut:
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
                        break;
                    case NSURLErrorNotConnectedToInternet:
                        errorDesc = @"呀！网络正在开小差(-1009)~";  /// 调试模式
                        break;
                    default:{
                        if (!self.reachabilityManager.isReachable){
                            /// 网络不给力，请检查网络
                            errorDesc = @"呜呜，网络正在开小差~";
                        }
                        break;
                    }
                }
            }else if (!self.reachabilityManager.isReachable){
                /// 网络不给力，请检查网络
                errorDesc = @"呜呜，网络正在开小差~";
            }
            break;
        }
    }
    userInfo[CMHHTTPServiceErrorHTTPStatusCodeKey] = @(HTTPCode);
    userInfo[CMHHTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[CMHHTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    
    /// 错误信息
    NSError *parsedError = [NSError errorWithDomain:CMHHTTPServiceErrorDomain code:errorCode userInfo:userInfo];
    
    /// 打印出错信息
    [self _HTTPRequestLog:task body:parameters error:parsedError];
    
    /// 回调错误信息
    !failure ? : failure(task , parsedError);
}



/// 解析错误信息
- (NSError *)_parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[CMHHTTPServiceErrorDescriptionKey] = localizedFailureReason;
    return [NSError errorWithDomain:CMHHTTPServiceErrorDomain code:CMHHTTPServiceErrorJSONParsingFailed userInfo:userInfo];
}

#pragma mark - 打印请求日志
- (void)_HTTPRequestLog:(NSURLSessionTask *)task body:params error:(NSError *)error{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>👇 REQUEST FINISH 👇>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"Request %@=======>:%@", error? @"失败":@"成功", task.currentRequest.URL.absoluteString);
    NSLog(@"requestBody======>:%@", params);
    NSLog(@"requstHeader=====>:%@", task.currentRequest.allHTTPHeaderFields);
    NSLog(@"response=========>:%@", task.response);
    NSLog(@"error============>:%@", error);
    NSLog(@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<");
}

@end
