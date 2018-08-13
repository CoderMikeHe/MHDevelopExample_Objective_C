//
//  CMHCoverSourceView.h
//  MHDevelopExample
//
//  Created by lx on 2018/7/20.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  封面资源

#import "CMHView.h"

@class CMHCoverSourceView;

@interface CMHCoverSourceView : CMHView<CMHConfigureView>
/// 回调
@property (nonatomic , readwrite , copy) void(^titleCallback)(CMHCoverSourceView *);
@end
