//
//  MHExample.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHExample : NSObject
/** 每段标题 */
@property (copy , nonatomic) NSString *header;
/** 每行标题 */
@property (strong , nonatomic) NSArray *titles;
/** 对应的控制器 */
@property (strong , nonatomic) NSArray *classes;
@end
