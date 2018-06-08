//
//  CMHExample.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHExample.h"

@implementation CMHExample
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    if (self = [super init]) {
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

+ (instancetype)exampleWithTitle:(NSString *)title subtitle:(NSString *)subtitle{
    return [[self alloc] initWithTitle:title subtitle:subtitle];
}
@end
