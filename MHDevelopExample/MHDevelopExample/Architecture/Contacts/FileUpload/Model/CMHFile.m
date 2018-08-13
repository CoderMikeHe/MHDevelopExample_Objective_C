//
//  CMHFile.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFile.h"


@implementation CMHFile

/// 将图片写入磁盘
+ (NSString *)writePictureFileToDisk:(NSData *)srcData{
    /// 将文件移动到这里
    /// 文件后缀
    NSString *suffix = @"png";
    /// 文件夹路径
    NSString *dirPath = [NSString stringWithFormat:@"%@",CMHFileCacheDirName];
    NSString *cachesDir = [CMHFileManager cachesDir];
    NSString *fileDirPath = [cachesDir stringByAppendingPathComponent:dirPath];
    
    if (![CMHFileManager isExistsAtPath:fileDirPath]) {
        [CMHFileManager createDirectoryAtPath:fileDirPath];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[self _cmh_fileName],suffix];
    /// 文件路径 CoderMikeHe Fixed Bug : 这里的文件路劲必须为相对路径，千万不要设置为绝对路径，因为随着版本的更新和升级，绝对路径会变 切记@！
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    
    /// 目标路径
    NSString *dstPath = [fileDirPath stringByAppendingPathComponent:fileName];
    
    /// 存图片过大 内存开销较大 ，需要优化处理
    BOOL rst = [srcData writeToFile:dstPath atomically:YES];

    NSLog(@" 存储图片文件（%@） 文件路径（%@） -----  %@" , fileName , filePath, rst?@"成功":@"失败");
    return rst ? filePath : nil;
    
}
/// 将某个文件移动到指定的文件夹中,主要作用就是将录制或者选择的视频文件，移动到指定的文件
+ (NSString *)moveVideoFileAtPath:(NSString *)srcPath{
    /// 将文件移动到这里
    /// 文件后缀
    NSString *suffix = srcPath.pathExtension;
    /// 文件夹路径
    NSString *dirPath = [NSString stringWithFormat:@"%@",CMHFileCacheDirName];
    
    NSString *cachesDir = [CMHFileManager cachesDir];
    NSString *fileDirPath = [cachesDir stringByAppendingPathComponent:dirPath];
    
    if (![CMHFileManager isExistsAtPath:fileDirPath]) {
        [CMHFileManager createDirectoryAtPath:fileDirPath];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[self _cmh_fileName],suffix];
    
    /// CoderMikeHe Fixed Bug : 这里的文件路劲必须为相对路径，千万不要设置为绝对路径，因为随着版本的更新和升级，绝对路径会变的 -- 切记@！
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    
    /// 目标路径
    NSString *dstPath = [fileDirPath stringByAppendingPathComponent:fileName];
    
    /// 移动文件 <剪切>
    BOOL rst = [CMHFileManager moveItemAtPath:srcPath toPath:dstPath overwrite:YES];
    
    NSLog(@" 移动视频文件（%@） 文件路径（%@） -----  %@" , fileName , filePath, rst?@"成功":@"失败");
    return rst ? filePath : nil;
}

#pragma mark - 辅助
/// 要上传的文件名
+ (NSString *)_cmh_fileName{
    static NSDateFormatter *formater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyyMMddHHmmss-SSS"];
    });
    return [formater stringFromDate:[NSDate date]];
}

//// 大文件拷贝
-(void)_copyFileFromPath:(NSString *)path1 toPath:(NSString *)path2{
    NSFileHandle * fh1 = [NSFileHandle fileHandleForReadingAtPath:path1];//读到内存
    [[NSFileManager defaultManager] createFileAtPath:path2 contents:nil attributes:nil];//写之前必须有该文件
    NSFileHandle * fh2 = [NSFileHandle fileHandleForWritingAtPath:path2];//写到文件
    NSData * _data = nil;
    unsigned long long ret = [fh1 seekToEndOfFile];//返回文件大小
    if (ret < 1024 * 1024 * 5) {//小于5M的文件一次读写
        [fh1 seekToFileOffset:0];
        _data = [fh1 readDataToEndOfFile];
        [fh2 writeData:_data];
    }else{
        NSUInteger n = ret / (1024 * 1024 * 5);
        if (ret % (1024 * 1024 * 5) != 0) {
            n++;
        }
        NSUInteger offset = 0;
        NSUInteger size = 1024 * 1024 * 5;
        for (NSUInteger i = 0; i < n - 1; i++) {
            //大于5M的文件多次读写
            [fh1 seekToFileOffset:offset];
            @autoreleasepool {
                /*该自动释放池必须要有否则内存一会就爆了
                 原因在于readDataOfLength方法返回了一个自动释放的对象,它只能在遇到自动释放池的时候才释放.如果不手动写这个自动释放池,会导致_data指向的对象不能及时释放,最终导致内存爆了.
                 */
                _data = [fh1 readDataOfLength:size];
                [fh2 seekToEndOfFile];
                [fh2 writeData:_data];
                NSLog(@"%lu/%lu", i + 1, n - 1);
            }
            offset += size;
        }
        //最后一次剩余的字节
        [fh1 seekToFileOffset:offset];
        _data = [fh1 readDataToEndOfFile];
        [fh2 seekToEndOfFile];
        [fh2 writeData:_data];
    }
    [fh1 closeFile];
    [fh2 closeFile];
}

@end
