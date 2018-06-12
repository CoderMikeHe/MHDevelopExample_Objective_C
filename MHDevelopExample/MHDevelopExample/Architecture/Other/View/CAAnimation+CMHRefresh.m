//
//  CAAnimation+CMHRefresh.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CAAnimation+CMHRefresh.h"

@implementation CAAnimation (CMHRefresh)

/// 旋转动画
+ (CABasicAnimation *)cmh_rotationAnimation{
    
    /// 配置基础动画
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    // 设置起点
    anim.fromValue= 0;
    
    // 设置终点
    anim.toValue=@(M_PI * 2);
    
    //设置动画执行一次的时长
    anim.duration= .3f;
    
    //设置速度函数
    anim.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //完成动画不删除：
    anim.removedOnCompletion = NO;
    
    //向前填充
    anim.fillMode= kCAFillModeForwards;
    
    //设置重复次数
    anim.repeatCount = MAXFLOAT;
    
    return anim;
}

+ (CABasicAnimation *) cmh_rotaAnimStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle{
    
    
    CABasicAnimation *anim =  [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    //设置起点
    anim.fromValue = @(startAngle * M_PI * 2);
    
    //设置终点(M_PI/180.0 * (x)
    anim.toValue=@(M_PI * endAngle * 2);
    
    //设置动画执行一次的时长
    anim.duration = 0.1f;
    
    //设置速度函数
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    //完成动画不删除：
    anim.removedOnCompletion = YES;
    
    //向前填充
    anim.fillMode = kCAFillModeForwards;
    
    //设置重复次数
    anim.repeatCount = 1;
    
    
    return anim;
}


@end
