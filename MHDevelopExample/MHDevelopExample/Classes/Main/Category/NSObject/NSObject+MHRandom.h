//
//  NSObject+MHRandom.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MHRandom)
// 获取 [to from] 之间的数据
+ (NSInteger) mh_randomNumber:(NSInteger)from to:(NSInteger)to;
@end
