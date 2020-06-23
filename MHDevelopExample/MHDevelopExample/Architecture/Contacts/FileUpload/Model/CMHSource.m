//
//  CMHSource.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHSource.h"
#import <CommonCrypto/CommonDigest.h>
#import "CMHFileSource.h"
#import "CMHFileUploadManager.h"
/// 表单保存成功
NSString *const CMHSaveSourceToDBSuccessNotification = @"CMHSaveSourceToDBSuccessNotification";
/// 表单数据
NSString *const CMHSaveSourceToDBSuccessInfoKey = @"CMHSaveSourceToDBSuccessInfoKey";

/// 假设当前登录的用户的ID
NSString *const CMHCurrentUserIdStr = @"1a2a3a4a5a6a7a8a9a0a";



@interface CMHSource ()

/// CoderMikeHe Fixed Bug : .m声明的属性也会存入数据库
/// fileSource
@property (nonatomic , readwrite , strong) CMHFileSource *fileSource;

@end


@implementation CMHSource

#pragma mark - BGFMDB
/**
 * 自定义“联合主键” ,这里指定 name和age 为“联合主键”.
 */
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"sourceId" , @"userId"];
}

/**
 如果模型中有数组且存放的是自定义的类(NSString等系统自带的类型就不必要了),那就实现该函数,key是数组名称,value是自定的类Class,用法跟MJExtension一样.
 (‘字典转模型’ 或 ’模型转字典‘ 都需要实现该函数)
 */
+(NSDictionary *)bg_objectClassInArray{
    return @{@"files":[CMHFile class]};
}

/**
 设置不需要存储的属性.
 */
+(NSArray *)bg_ignoreKeys{
    return @[@"disable",@"fileSource"];
}

#pragma mark - CMHSource
- (NSString *)userId{
    if (!_userId) {
#warning CMH TODO 实际开发中换成项目中的登录用户ID即可
        _userId = CMHCurrentUserIdStr;
    }
    return _userId;
}

- (NSString *)sourceId{
    if (_sourceId == nil) {
        _sourceId = [self _cmh_fileKey];
    }
    return _sourceId;
}

- (NSString *)coverUrl{
    if (_coverUrl == nil) {
        _coverUrl = [self _cmh_coverUrls][[NSObject mh_randomNumber:0 to:4]];
    }
    return _coverUrl;
}

- (NSString *)createDate{
    if (_createDate == nil) {
        _createDate = [self _cmh_createDate];
    }
    return _createDate;
}


//// ------------------------- 华丽分割线 --------------------------

#pragma mark -  数据库操作
/// 保存到数据库
- (void)saveSourceToDB:(void(^_Nullable)(BOOL isSuccess))complete{
    /// 异步存储数据
    [self bg_saveOrUpdateAsync:^(BOOL isSuccess) {
        /// 这里需要发个通知，告诉草稿页，表单有草稿数据新增
        dispatch_async(dispatch_get_main_queue(), ^{
            !complete ? : complete(isSuccess);
            if (!isSuccess) { return ; }
            /// 主线程发送
            [MHNotificationCenter postNotificationName:CMHSaveSourceToDBSuccessNotification object:nil userInfo:@{CMHSaveSourceToDBSuccessInfoKey:self}];
        });
    }];
}

/// 删除资源
+ (void)removeSourceFromDB:(NSString *)sourceId complete:(void(^_Nullable)(BOOL))complete{
    NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    
    [CMHSource bg_deleteAsync:nil where:where complete:^(BOOL isSuccess) {
        /// 将上传资源从数据库移除
        dispatch_async(dispatch_get_main_queue(), ^{
            !complete ? : complete(isSuccess);
        });
        
        if (!isSuccess) { return ; }
        
        /// 草稿资源删除成功
        [CMHFileSource removeFileSourceFromDB:sourceId complete:^(BOOL rst) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"+++ 💕上传资源删除%@💕 +++" , rst ? @"成功" : @"失败");
            });
        }];
    }];
}


/// 获取数据库
+ (void)fetchAllDrafts:(void (^_Nullable)(NSArray * _Nullable array))complete{
    /// 获取草稿数据
    /// 条件语句
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ order by %@ desc",bg_sqlKey(@"userId"),bg_sqlValue(CMHCurrentUserIdStr),bg_sqlKey(bg_updateTimeKey)];
    
    /// 获取数据
    [self bg_findAsync:nil where:where complete:^(NSArray * _Nullable array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !complete ? : complete(array);
        });
    }];
}

//// 获取所有需要上传的草稿数据
+ (NSArray *)fetchAllNeedUploadDraftData{
    /// 条件查询语句
    NSString *where = [NSString stringWithFormat:@"where %@ != %@ and %@ = %@ and %@ = 0 order by %@ desc", bg_sqlKey(@"uploadStatus"), @(CMHFileUploadStatusFinished), bg_sqlKey(@"userId"), bg_sqlValue(CMHCurrentUserIdStr), bg_sqlKey(@"manualSaveDraft"), bg_sqlKey(bg_updateTimeKey)];
    /// 查询数据
    return [self bg_find:nil where:where];
}



/// 获取资源
+ (CMHSource *)fetchSource:(NSString *)sourceId{
    
    NSString *where = [NSString stringWithFormat:@"where %@ = %@ and %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId),bg_sqlKey(@"userId"),bg_sqlValue(CMHCurrentUserIdStr)];
    NSArray *results = [self bg_find:nil where:where];
    
    if (results.count > 0) {
        return results.firstObject;
    }
    
    return nil;
}

/// 更新资源的进度
+ (void)updateSourceProgress:(CGFloat)progress sourceId:(NSString *)sourceId{
   
    NSString * where = [NSString stringWithFormat:@"set %@ = %lf where %@ = %@",bg_sqlKey(@"progress"),progress,bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    
    [self bg_update:nil where:where];
}

/// 更新资源上传状态
+ (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId{
    NSString * where = [NSString stringWithFormat:@"set %@ = %ld where %@ = %@",bg_sqlKey(@"uploadStatus"),uploadStatus,bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    [self bg_update:nil where:where];
}


#pragma mark - Method
+ (void)commitSource:(NSString *)sourceId{
    CMHSource *s = [self fetchSource:sourceId];
    if (MHObjectIsNil(s)) {
        /// 获取不到的情况，这种比较不常见
        /// 从数据库里面删除
        [self removeSourceFromDB:sourceId complete:NULL];
        /// 通知草稿页数据
        [[NSNotificationCenter defaultCenter] postNotificationName:CMHFileUploadDidFinishedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId}];
        return;
    }
    
    /// 这里调用提交资源的接口
    /// 模拟网络请求
    /// 2. 以下通过真实的网络请求去模拟获取 https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"isEnglish"] = @0;
    subscript[@"devicetype"] = @2;
    subscript[@"version"] = @"1.0.1";
    
    /// 2. 配置参数模型
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_HOT_TAB parameters:subscript.dictionary];
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:nil parsedResult:YES success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        /// 资源成功提交到服务器
        [self updateSourceProgress:1.0f sourceId:sourceId];
        [[CMHFileUploadManager sharedManager] updateUpLoadStatus:CMHFileUploadStatusFinished sourceId:sourceId];
        /// 从数据库里面删除
        [self removeSourceFromDB:sourceId complete:NULL];
        /// 通知草稿页数据
        [[NSNotificationCenter defaultCenter] postNotificationName:CMHFileUploadDidFinishedNotification object:nil userInfo:@{CMHFileUploadSourceIdKey : sourceId}];
        
        [MBProgressHUD mh_showTips:@"资源提交成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [[CMHFileUploadManager sharedManager] updateUpLoadStatus:CMHFileUploadStatusWaiting sourceId:sourceId];
        [[CMHFileUploadManager sharedManager] postFileUploadDisableStatusNotification:sourceId fileUploadDisabled:NO];
        [[CMHFileUploadManager sharedManager] postFileUploadStatusDidChangedNotification:sourceId];
    }];
}
- (void)commitSource:(void (^)(BOOL))complete{
    
    /// 1. 通过要上传的文件个数  去服务器获取对应的文件ID
    NSInteger uploadFileCount = self.files.count;
    
    /// 2. 以下通过真实的网络请求去模拟获取 文件ID的场景 https://live.9158.com/Room/GetHotTab?devicetype=2&isEnglish=0&version=1.0.1
    /// 类似于实际开发中调用服务器的API:  /fileSection/preLoad.do
    /// 1. 配置参数
    CMHKeyedSubscript *subscript = [CMHKeyedSubscript subscript];
    subscript[@"isEnglish"] = @0;
    subscript[@"devicetype"] = @2;
    subscript[@"version"] = @"1.0.1";
    
    /// 2. 配置参数模型
    CMHURLParameters *paramters = [CMHURLParameters urlParametersWithMethod:CMH_HTTTP_METHOD_GET path:CMH_GET_HOT_TAB parameters:subscript.dictionary];
    /// 3. 发起请求
    [[CMHHTTPRequest requestWithParameters:paramters] enqueueResultClass:nil parsedResult:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        /// - 如果到这里了就认为获取文件ID成功，这里模拟后台返回的数据 有几个上传文件 就对应几个上传文件ID
        NSMutableArray *fileIds = [NSMutableArray arrayWithCapacity:uploadFileCount];
        for (NSInteger i = 0; i < uploadFileCount; i++) {
            NSString *fileId = [self _cmh_fileKey];
            [fileIds addObject:fileId];
        }
        /// - 为每个上传文件绑定服务器返回的文件ID,获取要上传的文件块列表
        /// 将服务器文件ID列表转换为，转成json字符串，后期需要存数据库，这个fileIdsStr很重要
        NSString *fileIdsStr = fileIds.yy_modelToJSONString;
        /// 要上传的文件块列表
        NSMutableArray *fileBlocks = [NSMutableArray arrayWithCapacity:uploadFileCount];
        /// 生成上传文件以及绑定文件ID
        for (NSInteger i = 0; i < uploadFileCount; i++) {
            CMHFile *file = self.files[i];
            NSString *fileId = fileIds[i];
            
            /// 资源中的文件绑定文件ID
            file.fileId = fileId;
            /// 文件块
            CMHFileBlock *fileBlcok = [[CMHFileBlock alloc] initFileBlcokAtPath:file.filePath fileId:fileId sourceId:self.sourceId];
            [fileBlocks addObject:fileBlcok];
        }
        /// 生成上传文件资源
        CMHFileSource *fileSource = [[CMHFileSource alloc] init];
        fileSource.sourceId = self.sourceId;
        fileSource.fileIds = fileIdsStr;
        fileSource.fileBlocks = fileBlocks.copy;
        /// 保存文件和资源
        /// 非手动存草稿
        self.manualSaveDraft = NO;
        
        /// CoderMikeHe Fixed Bug : 这里必须记录必须强引用上传资源
        self.fileSource = fileSource;
        
        /// 先保存资源
        @weakify(self);
        [self saveSourceToDB:^(BOOL isSuccess) {
            if (!isSuccess) {
                !complete ? : complete(isSuccess);
                [MBProgressHUD mh_showTips:@"保存资源失败！！！"];
                return ;
            }
            @strongify(self);
            /// CoderMikeHe Fixed Bug : 这里必须用self.fileSource 而不是 fileSource ,因为这是异步，会导致 fileSource == nil;
            /// 保存上传资源
            @weakify(self);
            [self.fileSource saveFileSourceToDB:^(BOOL rst) {
                !complete ? : complete(rst);
                @strongify(self);
                /// 这里需要开始上传
                if (rst) {
                    [[CMHFileUploadManager sharedManager] uploadSource:self.sourceId];
                }else{
                    [MBProgressHUD mh_showTips:@"保存上传资源失败！！！"];
                }
            }];
        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        /// 回调错误
        !complete ? : complete(NO);
        /// show error
        [MBProgressHUD mh_showErrorTips:error];
    }];
}


#pragma mark - 辅助方法
/// 随机生成文件ID
- (NSString *)_cmh_fileKey {
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    CFRelease(uuid);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            (unsigned long)(arc4random() % NSUIntegerMax)];
}

/// 封面数组
-(NSArray *)_cmh_coverUrls{
  return @[@"http://img1.imgtn.bdimg.com/it/u=4187898496,3043946443&fm=27&gp=0.jpg" , @"http://img4.imgtn.bdimg.com/it/u=3964134380,1177908120&fm=27&gp=0.jpg" , @"http://img1.imgtn.bdimg.com/it/u=1175648843,2178002342&fm=27&gp=0.jpg" , @"http://img4.imgtn.bdimg.com/it/u=3818975264,3329086890&fm=27&gp=0.jpg" , @"http://img0.imgtn.bdimg.com/it/u=71343391,2567854601&fm=27&gp=0.jpg"];
}
/// 创建时间
- (NSString *)_cmh_createDate{
    static NSDateFormatter *formater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return [formater stringFromDate:[NSDate date]];
}
@end
