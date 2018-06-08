//
//  CMHExample.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"

@interface CMHExample : CMHObject

/// title
@property (nonatomic , readwrite , copy) NSString *title;

/// title
@property (nonatomic , readwrite , copy) NSString *subtitle;

/// Action
/// 点击这行cell，需要调转到哪个控制器的视图模型
@property (nonatomic, readwrite, assign) Class destClass;

/// 封装点击这行cell想做的事情
@property (nonatomic, readwrite, copy) void (^operation)(void);



/// Method
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
+ (instancetype)exampleWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
@end
