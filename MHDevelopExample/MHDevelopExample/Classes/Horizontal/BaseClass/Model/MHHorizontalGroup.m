//
//  MHHorizontalGroup.m
//  MHObjectiveC
//
//  Created by CoderMikeHe on 2018/12/14.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//  组

#import "MHHorizontalGroup.h"



@implementation MHHorizontalGroup

+ (NSArray<MHHorizontalGroup *> *)fetchHorizontalGroups{
    
    NSArray *titles = @[@"最近",@"特色",@"心情",@"人像",@"地点",@"时间",@"天气",@"美食"];
    NSArray *counts = @[@11,@24,@33,@33,@22,@17,@12,@33];
    
    
    NSUInteger count = titles.count;
    NSMutableArray *groups = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        
        MHHorizontalGroup *g = [[MHHorizontalGroup alloc] init];
        g.idstr = [NSString stringWithFormat:@"%ld",(1000 + i)];
        g.name = titles[i];
        
        NSInteger tempCount = [counts[i] integerValue];
        NSMutableArray *horizontals = [NSMutableArray arrayWithCapacity:tempCount];
        for (NSInteger j = 0; j < tempCount; j++) {
            MHHorizontal *h = [[MHHorizontal alloc] init];
            h.idstr = [NSString stringWithFormat:@"%ld",(10000 + j)];
            h.name = [NSString stringWithFormat:@"%@-%ld",g.name,j];
            
            /// 默认第一个选中
            h.selected = (i == 0) && (j == 0);
            
            [horizontals addObject:h];
        }
        
        g.horizontals = horizontals.copy;
        
        [groups addObject:g];
    }
    return groups.copy;
}


@end
