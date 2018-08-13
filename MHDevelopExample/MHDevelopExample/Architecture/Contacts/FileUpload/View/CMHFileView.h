//
//  CMHFileView.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHView.h"

@class CMHFileView,CMHFile;

@interface CMHFileView : CMHView<CMHConfigureView>
/// file
@property (nonatomic , readonly , strong) CMHFile *file;
/// 回调
@property (nonatomic , readwrite , copy) void(^deleteCallback)(CMHFileView *);
@end
