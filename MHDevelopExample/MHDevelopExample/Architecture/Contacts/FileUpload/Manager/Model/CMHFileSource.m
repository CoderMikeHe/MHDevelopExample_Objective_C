//
//  CMHFileSource.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.


#import "CMHFileSource.h"
#import <BGFMDB/BGFMDB.h>

@implementation CMHFileSource
#pragma mark - BGFMDB
/**
 * 自定义“联合主键” ,这里指定 name和age 为“联合主键”.
 */
+(NSArray *)bg_unionPrimaryKeys{
    return @[@"sourceId"];
}
/**
 设置不需要存储的属性.
 */
+(NSArray *)bg_ignoreKeys{
    return @[@"fileBlocks" , @"fileFragments"];
}



#pragma mark - Setter
- (void)setFileBlocks:(NSArray<CMHFileBlock *> *)fileBlocks{
    _fileBlocks = fileBlocks.copy;
    
    NSMutableArray *fileFragments = [NSMutableArray array];
    
    for (CMHFileBlock *fileBlock in fileBlocks) {
        [fileFragments addObjectsFromArray:fileBlock.fileFragments];
        self.totalFileFragment = self.totalFileFragment + fileBlock.totalFileFragment;
        self.totalFileSize = self.totalFileSize + fileBlock.totalFileSize;
    }
    self.fileFragments = fileFragments.copy;
    
    NSLog(@"👉 self.totalFileFragment --- %ld" , (long)self.totalFileFragment);
    NSLog(@"👉 self.totalFileSize --- %ld" , (long)self.totalFileSize);
}

#pragma mark - 数据库操作
/// 保存到数据库
- (void)saveFileSourceToDB:(void(^_Nullable)(BOOL isSuccess))complete{
    
    @weakify(self);
    [self bg_saveOrUpdateAsync:^(BOOL isSuccess) {
        @strongify(self);
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete(isSuccess);
            });
            return ;
        }
        /// 保存该资源下所有的片
        [CMHFileFragment bg_saveOrUpdateArrayAsync:self.fileFragments complete:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete(success);
                NSLog(@"+++ 💕所有的文件片存储%@💕 +++" , success ? @"成功" : @"失败");
            });
        }];
    }];
}

/// 保存数据库
- (void)saveOrUpdate{
    [self bg_saveOrUpdate];
}

/// 从数据库里面删除某一资源
+ (void)removeFileSourceFromDB:(NSString *)sourceId complete:(void (^)(BOOL))complete{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    [self bg_deleteAsync:nil where:where complete:^(BOOL isSuccess) {
        if (!isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete(isSuccess);
            });
            return ;
        }
        /// 移除所有的文件片
        [CMHFileFragment removeFileFragmentFromDB:sourceId complete:^(BOOL rst) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete(rst);
                NSLog(@"+++ 💕所有的文件片删除%@💕 +++" , rst ? @"成功" : @"失败");
            });
        }];
    }];
}

///  更新上传完成数量
+ (void)updateTotalSuccessFileFragment:(NSString *)sourceId{
    /// Tips
    /**
     格式：update 表名称 set 字段名称 = 字段名称 + 1 [ where语句]
     比如说数据库中有一张student表，要想把id为1的学生成绩（score）加1则
     update student set score=score+1 where id = 1
     */
    NSString * where = [NSString stringWithFormat:@"set %@ = %@+1 where %@ = %@",bg_sqlKey(@"totalSuccessFileFragment"),bg_sqlKey(@"totalSuccessFileFragment"),bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    /// 更新
    [self bg_update:nil where:where];
}

/// 更新上传资源的上传状态
+ (void)updateUpLoadStatus:(CMHFileUploadStatus)uploadStatus sourceId:(NSString *)sourceId{
    
    NSString * where = [NSString stringWithFormat:@"set %@ = %ld where %@ = %@",bg_sqlKey(@"uploadStatus"),uploadStatus,bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    [self bg_update:nil where:where];
}



/// 获取资源的上传进度
+ (CGFloat)fetchUploadProgress:(NSString *)sourceId{
    
    CGFloat progress = .0;
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    
    NSArray *array = [self bg_find:nil where:where];
    if (array.count>0) {
        CMHFileSource *source = [array firstObject];
        /// 这里让用户 *.9999 这样迷惑用户，因为真正上传完毕是资源提交成功
        progress = (source.totalSuccessFileFragment*0.1/source.totalFileFragment)*10*0.9999;
    }
    
    if (progress > 1.0) {
        progress = 1.0;
        NSLog(@"进度异常---》");
    }
    return progress;
}


/// 获取上传结果
+ (CMHFileUploadStatus)fetchFileUploadStatus:(NSString *)sourceId{
    
    CMHFileUploadStatus status = CMHFileUploadStatusWaiting;
    
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    
    NSArray *results = [self bg_find:nil where:where];
    
    if (results.count > 0) {
        
        CMHFileSource *fs = [results firstObject];
        
        if (fs.totalSuccessFileFragment >= fs.totalFileFragment) {
            fs.totalSuccessFileFragment = fs.totalFileFragment;
            status = CMHFileUploadStatusFinished;
        }
        fs.uploadStatus = status;
        [self bg_saveOrUpdateArrayAsync:results complete:^(BOOL isSuccess) {
            NSLog(@"😁😁😁😁 保存资源上传状态%@ 😁😁😁😁",isSuccess ? @"成功" : @"失败");
        }];
        
    }
    return status;
}


/// 获取上传资源
+ (CMHFileSource *)fetchFileSource:(NSString *)sourceId{
    NSString *where = [NSString stringWithFormat:@"where %@ = %@",bg_sqlKey(@"sourceId"),bg_sqlValue(sourceId)];
    NSArray *results = [self bg_find:nil where:where];
    if (results.count>0){
        return [results firstObject];
    }
    return nil;
}


/// 回滚该资源中失败的文件 <一般是后台返回的数据>
- (void)rollbackFailureFile:(NSArray *)failFileIds{
    /// 1. 将failFileIds的数据状态更改 CMHFileUploadStatusWaiting 状态
    /// 条件数组
    NSMutableArray *conditions = [NSMutableArray array];
    for (NSString *fileId in failFileIds) {
        NSString *sql = [NSString stringWithFormat:@"%@ = %@" , bg_sqlKey(@"fileId") , bg_sqlValue(fileId)];
        [conditions addObject:sql];
    }
    /// 拼接条件语句
    NSString *conditionSql = [conditions componentsJoinedByString:@" or "];
    /// 拼接 where 语句
    NSString *updateWhere = [NSString stringWithFormat:@"set %@ = %@ where %@ and %@ = %@" , bg_sqlKey(@"uploadStatus") , bg_sqlValue(@(CMHFileUploadStatusWaiting)) , conditionSql , bg_sqlKey(@"sourceId") , bg_sqlValue(self.sourceId)];
    NSLog(@"+++ updateWhere is %@" , updateWhere);
    /// 更新文件片的状态
    [CMHFileFragment bg_update:nil where:updateWhere];
    
    /// 2. 计算sql , 计算出数据库中上传成功的数据
    NSString *countWhere = [NSString stringWithFormat:@"where %@ = %@ and %@ = %@" , bg_sqlKey(@"uploadStatus") , bg_sqlValue(@(CMHFileUploadStatusFinished)) , bg_sqlKey(@"sourceId") , bg_sqlValue(self.sourceId)];
    /// 获取所有成功提交到服务器的数据
    NSInteger successCount = [CMHFileFragment bg_count:nil where:countWhere];
    NSLog(@"+++ countWhere is %@  successCount is %ld" , countWhere , (long)successCount);
    
    /// 3. 更新上传文件的总片数
    NSString * updateWhere1 = [NSString stringWithFormat:@"set %@ = %@ where %@=%@",bg_sqlKey(@"totalSuccessFileFragment"),bg_sqlValue(@(successCount)),bg_sqlKey(@"sourceId"),bg_sqlValue(self.sourceId)];
    [CMHFileSource bg_update:nil where:updateWhere1];
}


@end
