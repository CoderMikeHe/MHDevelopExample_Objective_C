//
//  CMHFileUploadManager.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/17.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileUploadManager.h"
#import "CMHSource.h"
#import "CMHFileUploadQueue.h"
#import "CMHFileSynthetise.h"


/// 某资源中的某片数据上传完成
NSString *const CMHFileUploadProgressDidChangedNotification = @"CMHFileUploadProgressDidChangedNotification";
/// 某资源的id
NSString *const CMHFileUploadSourceIdKey = @"CMHFileUploadSourceIdKey";
/// 某资源的进度
NSString *const CMHFileUploadProgressDidChangedKey = @"CMHFileUploadProgressDidChangedKey";

/// 某资源的所有片数据上传，完成也就是提交资源到服务器成功。
NSString *const CMHFileUploadDidFinishedNotification = @"CMHFileUploadDidFinishedNotification";
/// 资源文件上传状态改变的通知
NSString *const CMHFileUploadStatusDidChangedNotification = @"CMHFileUploadStatusDidChangedNotification";

/// 草稿上传文件状态 disable 是否不能点击 如果为YES 不要修改草稿页表单的上传状态 主需要让用户不允许点击上传按钮
NSString *const CMHFileUploadDisableStatusKey = @"CMHFileUploadDisableStatusKey";
NSString *const CMHFileUploadDisableStatusNotification = @"CMHFileUploadDisableStatusNotification";



@interface CMHFileUploadManager ()
/// 存放操作队列的字典
@property (nonatomic , readwrite , strong) NSMutableDictionary *uploadFileQueueDict;
/// 存放所有需要上传的资源id的数组
@property (nonatomic , readwrite , strong) NSMutableArray *uploadFileArray;
/// 是否是已加载 default is NO
@property (nonatomic , readwrite , assign , getter = isLoaded) BOOL loaded;


/// manager
@property (nonatomic , readwrite , strong) AFHTTPSessionManager *uploadService;

@end


@implementation CMHFileUploadManager

static CMHFileUploadManager * _sharedInstance = nil;
static dispatch_once_t onceToken;

#pragma mark - Public Method
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _sharedInstance;
}

/// 销毁单例
+ (void)deallocManager{
    /// 取消掉所有操作
    [_sharedInstance cancelAllUpload];
    
    onceToken = 0;
    _sharedInstance = nil;
}


- (instancetype)init{
    self = [super init];
    if (self) {
#warning CMH TODO 这里按照实际需要配置上传服务
        self.uploadService = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://live.9158.com/"/** 上传服务的baseUrl */] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
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
    self.uploadService.responseSerializer = responseSerializer;
    self.uploadService.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /// 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    
    self.uploadService.securityPolicy = securityPolicy;
    /// 支持解析
    self.uploadService.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                      @"text/json",
                                                      @"text/javascript",
                                                      @"text/html",
                                                      @"text/plain",
                                                      @"text/html; charset=UTF-8",
                                                      nil];
    
}


#pragma mark -

/// 基础配置，主要是后台上传草稿数据 一般在进入主页就立即配置
- (void)configure{
    /// 前提是必须登录
    NSString *userID = CMHCurrentUserIdStr;
    if (MHStringIsNotEmpty(userID)) {
        /// 防止用户操作,多次调用 configure
        [self cancelAllUpload];
        
        //// 查询需要上传的数据
        NSArray *drafts = [CMHSource fetchAllNeedUploadDraftData];
        
        for (CMHSource *df in drafts) {
            [self.uploadFileArray addObject:df.sourceId];
        }
        /// WiFI 状态下自动上传
        if (drafts.count > 0) { /// 有需要上传的草稿数据
#warning CMH TODO 这里按照实际情况去设计，如果打开下面注释，代表就是一旦调用 `configure` 则就会开启上传。 一般情况下我们会把 `configure` 的调用放在程序启动的时候调用
//            CMHSource *s = drafts.firstObject;
//            [self uploadSource:s.sourceId];
        }else{
            /// 删除废弃资源
            [self clearInvalidDiskCache];
        }
    }
}


/// 暂停上传 -- 用户操作
/// sourceId: 资源Id ✅
- (void)suspendUpload:(NSString *)sourceId{
    /// 用户手动暂停
    CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sourceId];
    /// 更新状态
    [self updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:sourceId];
    if (queue) {
        /// 用户手动暂停
        queue.manualPause = YES;
        if (!queue.isSuspended) { [queue setSuspended:YES]; }
    }else{
        NSLog(@"++++ 未找到要暂停的上传队列 ++++");
    }
    
    /// 告诉草稿页，该资源已经暂停，但这个已经在草稿页重置了，这里就不用发通知了
    /// [self postFileUploadStatusDidChangedNotification:sourceId];
    
    /// 上传下一个资源
    /// 0. 找一个要上传的资源ID
    NSString * findUploadSid = [self _findWaitingForUploadingSource];
    /// 这个 findUploadSid 有可能是暂停队列 ，所以不需要重新创建队列
    CMHFileUploadQueue *uploadQueue = [self.uploadFileQueueDict objectForKey:findUploadSid];
    if (uploadQueue) {
        [uploadQueue setSuspended:NO];
        /// 更新状态
        [self updateUpLoadStatus:CMHFileUploadStatusUploading sourceId:findUploadSid];
        /// 告知草稿页其状态
        [self postFileUploadStatusDidChangedNotification:findUploadSid];
    }else{
        /// 1. 继续上传资源
        [self uploadSource:findUploadSid];
    }
}

/// 继续上传 -- 用户操作 ✅
/// sourceId: 资源Id
- (void)resumeUpload:(NSString *)sourceId{
    
    /// 找一个正在上传的资源，并将其暂停掉，满足一次性只能上传一个的需求
    NSString *uploadingSid = [self _findUploadingSource];
    if (MHStringIsNotEmpty(uploadingSid)) {
        /// 存在并将其暂停
        CMHFileUploadQueue *uploadingQueue = [self.uploadFileQueueDict objectForKey:uploadingSid];
        uploadingQueue.manualPause = NO;  /// 程序暂停，非手动暂停
        [uploadingQueue setSuspended:YES];
        
        /// 更新数据库状态
        [self updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:uploadingSid];
        /// 告诉草稿
        [self postFileUploadStatusDidChangedNotification:uploadingSid];
    }
    
    /// 看是否有个队列
    CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sourceId];
    [self updateUpLoadStatus:CMHFileUploadStatusUploading sourceId:sourceId];
    if (queue) { /// 如果有个队列，则
        queue.manualPause = NO;
        if (queue.isSuspended) { [queue setSuspended:NO]; }
    }else{
        NSLog(@"++++ 未找到对应的重启上传队列 ++++");
        /// 不存在队列则，重新开启一个队列
        [self uploadSource:sourceId];
    }
}

/// 取消掉上传 -- 用户操作  <场景：删除某个资源> ✅
/// sourceId: 资源Id
- (void)cancelUpload:(NSString *)sourceId{

    /// 更新状态
    [self updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:sourceId];
    /// 看是否存在队列
    CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sourceId];
    if (queue) {
        /// 取消所有操作，无法继续上传，必须重新开启队列
        if (!queue.isSuspended) { [queue setSuspended:YES]; }
        [queue cancelAllOperations];
    }else{
        NSLog(@"++++ 未找到要取消的上传队列 ++++");
    }
    
    /// 移除掉资源
    [self.uploadFileQueueDict removeObjectForKey:sourceId];
    [self _removeSourceFromUploadFileArray:sourceId];
    
    /// 开启下一个资源
    
    /// 上传下一个资源
    /// 0. 找一个要上传的资源ID
    NSString * findUploadSid = [self _findWaitingForUploadingSource];
    /// 这个 findUploadSid 有可能是暂停队列 ，所以不需要重新创建队列
    CMHFileUploadQueue *uploadQueue = [self.uploadFileQueueDict objectForKey:findUploadSid];
    if (uploadQueue) {
        [uploadQueue setSuspended:NO];
        /// 更新状态
        [self updateUpLoadStatus:CMHFileUploadStatusUploading sourceId:findUploadSid];
        /// 告知草稿页其状态
        [self postFileUploadStatusDidChangedNotification:findUploadSid];
    }else{
        /// 1. 继续上传资源
        [self uploadSource:findUploadSid];
    }
}

/// 取消掉所有上传 <场景：切换账号 或 重新配置> ✅
- (void)cancelAllUpload{
    /// 遍历资源，结束任务
    for (NSString *sid in self.uploadFileArray) {
        /// 获取queue
        CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sid];
        [queue setSuspended:YES];
        /// 取消掉所有任务
        [queue cancelAllOperations];
    }
    /// 归零处理
    self.uploadFileArray = nil;
    self.uploadFileQueueDict = nil;
}

/// 删除当前用户无效的资源
- (void)clearInvalidDiskCache{
    #warning CMH TODO 删除废弃资源
}

/// 以下方法跟服务器交互，只管调用即可，无需回调，
/// 清除掉已经上传到服务器的文件片 fileSection <场景：点删除按钮>
- (void)deleteUploadedFile:(NSString *)sourceId{
    
    /// 这里调用服务器的接口检查文件上传状态，以这个为标准
    CMHFileSource *fileSource = [CMHFileSource fetchFileSource:sourceId];
    if (fileSource == nil || MHStringIsEmpty(fileSource.fileIds)) {
        return; /// 没意义
    }
    
    /// 这里笔者只是模拟一下网络情况哈，不要在乎这些细节 。。。
    /// 类似于实际开发中调用服务器的API:  fileSection/delete.do
    /// 2. 以下通过真实的网络请求去模拟获取 文件ID的场景 https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"isEnglish"] = @0;
    subscript[@"devicetype"] = @2;
    subscript[@"version"] = @"1.0.1";
    /// 2. 配置参数模型
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_HOT_TAB parameters:subscript.dictionary];
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:nil parsedResult:YES success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSLog(@"😁😁😁 Delete File Section Success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"😭😭😭 Delete File Section Failure");
    }];

}

/// 上传资源 核心方法
- (void)uploadSource:(NSString *)sourceId{
    
    if (!MHStringIsNotEmpty(sourceId)) { return; }
    
    /// CoderMikeHe Fixed Bug : 解决初次加载的问题,不需要验证网络
    if (self.isLoaded) {
        if (![AFNetworkReachabilityManager sharedManager].isReachable) { /// 没有网络
            [self postFileUploadStatusDidChangedNotification:sourceId];
            return;
        }
    }
    self.loaded = YES;
    
    
    /// - 获取该资源下所有未上传完成的文件片
    NSArray *uploadFileFragments = [CMHFileFragment fetchAllWaitingForUploadFileFragment:sourceId];
    
    if (uploadFileFragments.count == 0) {
        
        /// 没有要上传的文件片
        
        /// 获取上传资源
        CMHFileSource *fileSource = [CMHFileSource fetchFileSource:sourceId];
        /// 获取资源
        CMHSource *source = [CMHSource fetchSource:sourceId];
        
        if (MHObjectIsNil(source)) {
            
            /// 提交下一个资源
            [self _autoUploadSource:sourceId reUpload:NO];
            
            /// 没有资源，则🈶何须上传资源，将数据库里面清掉
            [CMHFileSource removeFileSourceFromDB:sourceId complete:NULL];
            /// 通知草稿页 删除词条数据
            [[NSNotificationCenter defaultCenter] postNotificationName:CMHFileUploadDidFinishedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId}];

            return;
        }
        
        if (MHObjectIsNil(fileSource)) {
            
            /// 提交资源
            [self _autoUploadSource:sourceId reUpload:NO];
            
            /// 没有上传资源 ，则直接提交
            [[CMHFileUploadManager sharedManager] postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:YES];
            [self _commitSource:sourceId];
            return;
        }
        
        if (fileSource.totalFileFragment <= 0) {
            
            /// 提交资源
            [self _autoUploadSource:sourceId reUpload:NO];
            
            /// 没有上传文件片
            [[CMHFileUploadManager sharedManager] postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:YES];
            [self _commitSource:sourceId];
            return;
        }
        
        /// 倒了这里 ， 证明 fileSource,source 有值，且 fileSource.totalFileFragment > 0
        CMHFileUploadStatus uploadStatus = [CMHFileSource fetchFileUploadStatus:sourceId];
        if (uploadStatus == CMHFileUploadStatusFinished) {
            // 文件全部上传成
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                /// 检查服务器的文件上传合成状态
                [self _checkFileFragmentSynthetiseStatusFromService:sourceId];
            });
        }else{
            /// 到了这里，则证明这个草稿永远都不会上传成功了，这里很遗憾则需要将其从数据库中移除
            /// 提交资源
            [self _autoUploadSource:sourceId reUpload:NO];
            
            [CMHSource removeSourceFromDB:sourceId complete:NULL];
            /// 通知草稿页 删除这条数据
            [[NSNotificationCenter defaultCenter] postNotificationName:CMHFileUploadDidFinishedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId}];
        }
        return;
    }
    
    
    
    /// 0. 这里一定会新建一个新的上传队列，一定会开启一个新的任务
    /// - 看是否存在于上传数组中
    NSString *findSid = nil;
    /// - 是否有文件正在上传
    BOOL isUploading = NO;
    
    for (NSString *sid in self.uploadFileArray) {
        /// 上传资源里面已经存在了，findSid
        if ([sid isEqualToString:sourceId]) {
            findSid = sid;
        }
        /// 查看当前是否有上传任务正在上传
        CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sid];
        if (queue && !queue.isSuspended) {
            isUploading = YES;
        }
    }
    
    /// 2. 检查状态，插入数据，
    if (findSid) { /// 已经存在了，那就先删除，后插入到第0个元素
        [self.uploadFileArray removeObject:findSid];
        [self.uploadFileArray insertObject:sourceId atIndex:0];
    }else{ /// 不存在上传资源数组中，直接插入到第0个元素
        [self.uploadFileArray insertObject:sourceId atIndex:0];
    }
    
    /// 3. 检查是否已经有上传任务了
    if (isUploading) { /// 已经有正在上传任务了，则不需要开启队列了,就请继续等待
        /// 发送通知
        [self postFileUploadStatusDidChangedNotification:sourceId];
        return;
    }
    /// 4. 如果没有上传任务，你就创建队里开启任务即可

    /// 更新这个上传文件的状态 为 `正在上传的状态`
    [self updateUpLoadStatus:CMHFileUploadStatusUploading sourceId:sourceId];
    
    /// 创建信号量 用于线程同步
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    /// 创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    /// 操作数
    NSMutableArray *operations = [NSMutableArray array];
    
    /// 这里采用串行队列且串行请求的方式处理每一片的上传
    for (CMHFileFragment *ff in uploadFileFragments) {
        /// 进组
        dispatch_group_enter(group);
        // 创建对象，封装操作
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            
            /// 切记：任务(网络请求)是串行执行的 ，但网络请求结果回调是异步的、
            [self _uploadFileFragment:ff
                             progress:^(NSProgress *progress) {
                                 NSLog(@" \n上传文件ID👉【%@】\n上传文件片👉 【%ld】\n上传进度为👉【%@】",ff.fileId, (long)ff.fragmentIndex, progress.localizedDescription);
                             }
                              success:^(id responseObject) {
                                  /// 处理成功的文件片
                                  [self _handleUploadFileFragment:ff];
                                  /// 退组
                                  dispatch_group_leave(group);
                                  /// 信号量+1 向下运行
                                  dispatch_semaphore_signal(semaphore);
                              } failure:^(NSError *error) {
                                  /// 更新数据
                                  /// 某片上传失败
                                  [ff updateFileFragmentUploadStatus:CMHFileUploadStatusWaiting];
                                  /// 退组
                                  dispatch_group_leave(group);
                                  /// 信号量+1 向下运行
                                  dispatch_semaphore_signal(semaphore);
                                  
                              }];
            /// 等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }];
        /// 添加操作数组
        [operations addObject:operation];
    }
    /// 创建NSOperationQueue
    CMHFileUploadQueue * uploadFileQueue = [[CMHFileUploadQueue alloc] init];
    /// 存起来
    [self.uploadFileQueueDict setObject:uploadFileQueue forKey:sourceId];
    /// 把操作添加到队列中 不需要设置为等待
    [uploadFileQueue addOperations:operations waitUntilFinished:NO];
    
    /// 队列组的操作全部完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"😁😁😁+++dispatch_group_notify+++😁😁😁");
        /// 0. 如果运行到这，证明此`Queue`里面的所有操作都已经全部完成了，你如果再使用 [queue setSuspended:YES/NO];将没有任何意义，所以你必须将其移除掉
        [self.uploadFileQueueDict removeObjectForKey:sourceId];
        /// 1. 队列完毕了，清除掉当前的资源，开启下一个资源
        [self _removeSourceFromUploadFileArray:sourceId];
        /// CoderMikeHe: 这里先不更新草稿页的状态，等提交完表格再去发送通知
        /// 检查一下资源上传
        [self _uploadSourceEnd:sourceId];
    });
    
    //// 告知外界其资源状态改过了
    [self postFileUploadStatusDidChangedNotification:sourceId];
}


/// 告知草稿页，某个资源的上传状态改变
- (void)postFileUploadStatusDidChangedNotification:(NSString *)sourceId{
    /// 发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        /// CoderMikeHe Fixed Bug: 这里需要在主线程里面发通知 , 以免接收此通知的的线程在子线程里面，刷新UI，导致Crash
        [MHNotificationCenter postNotificationName:CMHFileUploadStatusDidChangedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId}];
    });
}
/// 告知草稿页，某个资源不允许点击
- (void)postFileUploadDisableStatusNotification:(NSString *)sourceId fileUploadDisabled:(BOOL)fileUploadDisabled{
    /// 发送通知
    dispatch_async(dispatch_get_main_queue(), ^{
        /// CoderMikeHe Fixed Bug: 这里需要在主线程里面发通知 , 以免接收此通知的的线程在子线程里面，刷新UI，导致Crash
        [MHNotificationCenter postNotificationName:CMHFileUploadDisableStatusNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId , CMHFileUploadDisableStatusKey : @(fileUploadDisabled)}];
    });
}

/// 更新资源的状态
- (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId{
    /// 更新上传资源的上传状态
    [CMHFileSource updateUpLoadStatus:uploadStatus sourceId:sourceId];
    /// 更新上传资源的上传状态
    [CMHSource updateUpLoadStatus:uploadStatus sourceId:sourceId];
}


#pragma mark - Private Method
/// 上传某一片文件 这里用作测试
- (void)_uploadFileFragment:(CMHFileFragment *)fileFragment
                   progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure{
    /// 获取上传参数
    NSDictionary *parameters = [fileFragment fetchUploadParamsInfo];
    /// 获取上传数据
    NSData *fileData = [fileFragment fetchFileFragmentData];
    
    /// 资源文件找不到，则直接修改数据库，无论如何也得让用户把资源提交上去，而不是让其永远卡在草稿页里，这样太影响用户体验了
    if (fileData == nil) {
        /// CoderMikeHe Fixed Bug : V1.6.7之前 修复文件丢失的情况
        /// 1. 获取该片所处的资源
        CMHFileSource *uploadSource = [CMHFileSource fetchFileSource:fileFragment.sourceId];
        /// 取出fileID
        NSMutableArray *fileIds = [NSMutableArray arrayWithArray:uploadSource.fileIds.yy_modelToJSONObject];
        
        NSLog(@"😭😭😭😭 Before -- 文件<%@>未找到个数 %ld <%@> 😭😭😭😭",fileFragment.fileId , fileIds.count, fileIds);
        if ([fileIds containsObject:fileFragment.fileId]) {
            /// 数据库包含
            [fileIds removeObject:fileFragment.fileId];
            uploadSource.fileIds = fileIds.yy_modelToJSONString;
            /// 更新数据库
            [uploadSource saveOrUpdate];
        }
        NSLog(@"😭😭😭😭 After -- 文件<%@>未找到个数 %ld <%@> 😭😭😭😭",fileFragment.fileId , fileIds.count, fileIds);
        
        /// 一定要回调为成功，让用户误以为正在上传，而不是直接卡死在草稿页
        NSDictionary *responseObj = @{@"code" : @200};
        !success ? : success(responseObj);
        return;
    }
    
    /// 这里笔者只是模拟一下网络情况哈，不要在乎这些细节 ，
    /// 类似于实际开发中调用服务器的API:  /fileSection/upload.do
    /// 2. 以下通过真实的网络请求去模拟获取 文件ID的场景 https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"isEnglish"] = @0;
    subscript[@"devicetype"] = @2;
    subscript[@"version"] = @"1.0.1";
    
    /// 2. 配置参数模型
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_HOT_TAB parameters:subscript.dictionary];
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:nil parsedResult:YES success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
#warning CMH TODO 稍微延迟一下，模拟现实情况下的上传进度
        NSInteger randomNum = [NSObject mh_randomNumber:0 to:5];
        [NSThread sleepForTimeInterval:0.1 * randomNum];
        
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        !failure ? : failure(error);
    }];

#if 0
    /// 这个是真实上传，请根据自身实际项目出发  /fileSection/upload.do
    [self _uploadFileFragmentWithParameters:parameters
                                   fileType:fileFragment.fileType
                                   fileData:fileData
                                   fileName:fileFragment.fileName
                                   progress:uploadProgress
                                    success:success
                                    failure:failure];
#endif
    
}


/// 实际开发项目中上传每一片文件，这里请结合自身项目开发去设计
- (NSURLSessionDataTask *)_uploadFileFragmentWithParameters:(NSDictionary *)parameters
                                                   fileType:(CMHFileType)fileType
                                                   fileData:(NSData *)fileData
                                                   fileName:(NSString *)fileName
                                                   progress:(void (^)(NSProgress *))uploadProgress
                                                    success:(void (^)(id responseObject))success
                                                    failure:(void (^)(NSError *error))failure{
    /// 配置成服务器想要的样式
    NSMutableArray *paramsArray = [NSMutableArray array];
    [paramsArray addObject:parameters];
    
    /// 生成jsonString
    NSString *jsonStr = [paramsArray yy_modelToJSONString];
    
    /// 设置TTPHeaderField
    [self.uploadService.requestSerializer setValue:jsonStr forHTTPHeaderField:@"file_block"];

    /// 开启文件任务上传
    /// PS : 着了完全可以看成，我们平常上传头像给服务器一样的处理方式
    NSURLSessionDataTask *uploadTask = [self.uploadService POST:@"/fileSection/upload.do" parameters:nil/** 一般这里传的是基本参数 */ constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /// 拼接mimeType
        NSString *mimeType = [NSString stringWithFormat:@"%@/%@",(fileType == CMHFileTypePicture) ? @"image":@"video",[[fileName componentsSeparatedByString:@"."] lastObject]];
        
        /// 拼接数据
        [formData appendPartWithFileData:fileData name:@"sectionFile" fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * progress) {
        !uploadProgress ? : uploadProgress(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ? : failure(error);
    }];
    return uploadTask;
}


/// 处理文件片上传成功
- (void)_handleUploadFileFragment:(CMHFileFragment *)ff{
    //更新数据
#warning CMH TODO 是否需要做文件丢失处理
//    CMHFileUploadQueue *queue = self.uploadFileQueueDict[sourceId];
//    if (!queue.isSuspended) {
//        /// 做一次文件丢失处理，这里根据实际项目确定，因为这样会导致暂停了，但请求已经发了，则响应还是会回来，会导致草稿页的进度条在暂停状态下会跳动一丢丢 ，但是只是小问题，
//    }
    
    /// 修改某片的上传状态为成功
    [ff updateFileFragmentUploadStatus:CMHFileUploadStatusFinished];
    
    /// 更新上传进度
    CGFloat progress =  [self _fetchAndUpdateSourceUploadProgress:ff.sourceId];
    
    /// 发送通知资源文件进度更新的通知
    dispatch_async(dispatch_get_main_queue(), ^{
        /// CoderMikeHe Fixed Bug: 这里需要在主线程里面发通知 , 以免接收此通知的的线程在子线程里面，刷新UI，导致Crash
        [MHNotificationCenter postNotificationName:CMHFileUploadProgressDidChangedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : ff.sourceId , CMHFileUploadProgressDidChangedKey : @(progress)}];
    });
}

// 获取和更新资源上传进度
- (CGFloat)_fetchAndUpdateSourceUploadProgress:(NSString *)sourceId{
    /// 更新资源已经完成的片数
    [CMHFileSource updateTotalSuccessFileFragment:sourceId];
    /// 获取当前资源的上传进度
    CGFloat progress = [CMHFileSource fetchUploadProgress:sourceId];
    NSLog(@"😁😁😁 --- 资源上传总进度 👉 %f" , progress);
    /// 更新表单上传进度
    [CMHSource updateSourceProgress:progress sourceId:sourceId];
    return progress;
}

/// 该资源上传结束 <该资源下所有的文件片已经都调用了 _uploadFileFragment 方法，当然有成功和失败>
- (void)_uploadSourceEnd:(NSString *)sourceId{
    ///
    /// 两种情况
    /// 1. 所有文件都上传成功
    /// 2. 仅有部分文件上传成功
    CMHFileUploadStatus uploadStatus = [CMHFileSource fetchFileUploadStatus:sourceId];
    if (uploadStatus == CMHFileUploadStatusFinished) {
        // 文件全部上传成
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            /// 检查服务器的文件上传合成状态
            [self _checkFileFragmentSynthetiseStatusFromService:sourceId];
        });
    }else{
        /// 文件部分上传成功
        NSLog(@"+++++ 部分文件尚未上传成功 +++++");
        /// 更新上传资源以及数据库资源的上传状态
        [self updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:sourceId];
        /// 更新草稿状态
        [self postFileUploadStatusDidChangedNotification:sourceId];
        /// 继续上传该资源
        [self _autoUploadSource:sourceId reUpload:YES];
    }
}


/// 检查服务器文件片合成情况
- (void)_checkFileFragmentSynthetiseStatusFromService:(NSString *)sourceId{
    
    /// 这里调用服务器的接口检查文件上传状态，以这个为标准
    CMHFileSource *uploadSource = [CMHFileSource fetchFileSource:sourceId];
    /// 没意义
    if (uploadSource == nil) { return; }
    
    /// 如果这里进来了，则证明准备验证文件片和提交表单，则草稿里面的这块表单，你不能在让用户去点击了
    [self postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:YES];
    
    /// V1.6.5之前的接口老数据
    if (!MHStringIsNotEmpty(uploadSource.fileIds)) {
        /// 这里可能是老数据，直接认为成功，就不要去跟服务器打交道了
        /// 成功
        [self _commitSource:sourceId];
        /// 上传下一个
        [self _autoUploadSource:sourceId reUpload:NO];
        return;
    }
    /// 这里笔者只是模拟一下网络情况哈，不要在乎这些细节，
    /// 类似于实际开发中调用服务器的API:  /fileSection/isFinish.do
    /// 2. 以下通过真实的网络请求去模拟获取 文件ID的场景 https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"isEnglish"] = @0;
    subscript[@"devicetype"] = @2;
    subscript[@"version"] = @"1.0.1";
    
    /// 2. 配置参数模型
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_HOT_TAB parameters:subscript.dictionary];
    
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:nil parsedResult:YES success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        
        /// 模拟后台返回的合成结果
        CMHFileSynthetise *fs = [[CMHFileSynthetise alloc] init];
        NSInteger randomNum = [NSObject mh_randomNumber:0 to:20];
        fs.finishStatus = (randomNum > 0) ? 1 : 0;  /// 模拟服务器合成失败的场景，毕竟合成失败的几率很低
        
        if (fs.finishStatus>0) {
            /// 服务器合成资源文件成功
            /// 成功
            [self _commitSource:sourceId];
            /// 上传下一个
            [self _autoUploadSource:sourceId reUpload:NO];
            return ;
        }
        
        /// 服务器合成资源文件失败， 服务器会把合成失败的 fileId 返回出来
        /// 也就是 "failFileIds" : "fileId0,fileId1,..."的格式返回出来
        /// 这里模拟后台返回合成错误的文件ID, 这里只是演习！！这里只是演习！！
        /// 取出fileID
        NSMutableArray *fileIds = [NSMutableArray arrayWithArray:uploadSource.fileIds.yy_modelToJSONObject];
        /// 模拟只有一个文件ID合成失败
        NSString *failFileIds = fileIds.firstObject;
        fs.failFileIds = failFileIds;
        
        /// 这里才是模拟真实的网络情况
        if (MHStringIsNotEmpty(fs.failFileIds)) {
            /// 1. 回滚数据
            [uploadSource rollbackFailureFile:fs.failureFileIds];
            /// 2. 获取进度
            CGFloat progress = [CMHFileSource fetchUploadProgress:sourceId];
            /// 3. 发送通知
            [MHNotificationCenter postNotificationName:CMHFileUploadProgressDidChangedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId , CMHFileUploadProgressDidChangedKey : @(progress)}];
            /// 4. 重新设置回滚数据的经度
            [CMHSource updateSourceProgress:progress sourceId:sourceId];
        }else{
            /// 无需回滚，修改状态即可
            [self postFileUploadStatusDidChangedNotification:sourceId];
        }
        
        /// 合成失败，继续重传失败的片，允许用户点击草稿页的资源
        [self postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:NO];
        /// 重传该资源
        [self _autoUploadSource:sourceId reUpload:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        /// 1. 服务器报错不重传
        [MBProgressHUD mh_showErrorTips:error];
        
        /// 更新资源状态
        [self updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:sourceId];
        
        /// 更新状态
        [self postFileUploadStatusDidChangedNotification:sourceId];
        /// 文件片合成失败，允许点击
        [self postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:NO];
    }];
}

/// 提交表单资源
- (void)_commitSource:(NSString *)sourceId{
    /// 提交资源
    [CMHSource commitSource:sourceId];
}

#pragma mark - 辅助方法
/// 查找一个待上传的资源 ✅
- (NSString *)_findWaitingForUploadingSource{
    
    NSString * findUploadSid = nil;
    
    for (NSString *sid in self.uploadFileArray) {
        /// 获取queue
        CMHFileUploadQueue *queue = [self.uploadFileQueueDict objectForKey:sid];
        if (queue == nil) { /// 没有上传队列
            findUploadSid = sid;
            break;
        }else{  /// 已经有上传队列
            if (!queue.isManualPause && queue.isSuspended) { /// 如果不是手动暂停的暂停队列 且 不是暂停状态
                findUploadSid = sid;
                break;
            }
        }
    }
    return findUploadSid;
}

/// 找一个正在上传的资源 ✅
- (NSString *)_findUploadingSource{
    
    NSString * findUploadSid = nil;
    for (NSString *sid in self.uploadFileArray) {
        /// 获取queue
        CMHFileUploadQueue *queue = [self.uploadFileQueueDict valueForKey:sid];
        if (queue == nil) { /// 没有上传队列
            continue;
        }else{  /// 已经有上传队列
            if (!queue.isSuspended) { /// 是否正在启动
                findUploadSid = sid;
                break;
            }
        }
    }
    return findUploadSid;
}

/// 从上传资源数组里面删除某个资源 ✅
- (void)_removeSourceFromUploadFileArray:(NSString *)fileId{
    for (NSString *sid in self.uploadFileArray.reverseObjectEnumerator) {
        if ([sid isEqualToString:fileId]) {
            [self.uploadFileArray removeObject:sid];
        }
    }
}

/// 自动上传资源
/// reUpload -- 代表是否需要重传 ✅
- (void)_autoUploadSource:(NSString *)sourceId reUpload:(BOOL)reUpload{
    if (reUpload) {
        /// 继续上传资源
        [self uploadSource:sourceId];
    }else{
        /// CoderMikeHe Fixed Bug : 去掉大量的冗余数据
        /// 0. 如果运行到这，证明此`Queue`里面的所有操作都已经全部完成了，你如果再使用 [queue setSuspended:YES/NO];将没有任何意义，所以你必须将其移除掉
        [self.uploadFileQueueDict removeObjectForKey:sourceId];
        /// 1. 队列完毕了，清除掉当前的资源，开启下一个资源
        [self _removeSourceFromUploadFileArray:sourceId];
        /// 2. 细节处理，过滤掉那些用户手动暂停的情况
        NSString * findUploadSid = [self _findWaitingForUploadingSource];
        
        /// 这个 findUploadSid 有可能是暂停队列 ，所以不需要重新创建队列
        CMHFileUploadQueue *uploadQueue = [self.uploadFileQueueDict objectForKey:findUploadSid];
        if (uploadQueue) {
            [uploadQueue setSuspended:NO];
            /// 更新状态
            [self updateUpLoadStatus:CMHFileUploadStatusUploading sourceId:findUploadSid];
            /// 告知草稿页其状态
            [self postFileUploadStatusDidChangedNotification:findUploadSid];
        }else{
            /// 1. 继续上传资源
            [self uploadSource:findUploadSid];
        }
    }
}

#pragma mark - Getter & Setter
- (NSMutableArray *)uploadFileArray{
    if (_uploadFileArray == nil) {
        _uploadFileArray  = [[NSMutableArray alloc] init];
    }
    return _uploadFileArray ;
}

- (NSMutableDictionary *)uploadFileQueueDict{
    if (_uploadFileQueueDict == nil) {
        _uploadFileQueueDict = [NSMutableDictionary dictionary];
    }
    return _uploadFileQueueDict ;
}


/**
 Tips : iOS字典 setValue 和 setObject的区别
 
 NSString name = @"张三";
 NSString name1 = nil;
 
 NSMutableDictionary *paramters = [[NSMutableDictionary alloc] init];
 [paramters setObject:name forKey:@"userName"]; // 不会奔溃
 
 NSMutableDictionary *paramters1 = [[NSMutableDictionary alloc] init];
 [paramters setObject:name1 forKey:@"userName"]; // 奔溃
 
 setObejct的value不能为nil
 
 所以在项目中  传参数的时候 有时候会因为值为nil而奔溃，相信都有遇到过吧。 如果使用setObject 一定要保证value不能为nil
 
 如果要value为nil 但又不会让其奔溃怎么办，那就要使用setValue
 NSMutableDictionary *paramters2 = [[NSMutableDictionary alloc] init];
 [paramters setValue:name forKey:@"userName"]; // 不会奔溃
 
 NSMutableDictionary *paramters3 = [[NSMutableDictionary alloc] init];
 [paramters setValue:name1 forKey:@"userName"]; // 不会奔溃
 如果使用setValue 当value为nil的时候 会自己调用 下面这个方法
 - (void)setValue:(id)value forUndefinedKey:(NSString *)key
 {
 
 }
 
 /// https://blog.csdn.net/u010850094/article/details/51259268
 
 
 */






@end
