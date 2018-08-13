//
//  CMHFileSynthetise.h
//  MHDevelopExample
//
//  Created by lx on 2018/8/7.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  调用 /fileSection/isFinish.do 接口返回文件的合成结果

#import "CMHObject.h"

@interface CMHFileSynthetise : CMHObject
/// 检查下当次上传数据所有文件是否上传完毕 0-未完成；1-已完毕
@property (nonatomic , readwrite , assign) NSInteger finishStatus;

/// 失败的文件 'fileId1, fileId2,...'
@property (nonatomic , readwrite , copy) NSString *failFileIds;

/// 失败的文件
@property (nonatomic , readonly , copy) NSArray *failureFileIds;
@end
