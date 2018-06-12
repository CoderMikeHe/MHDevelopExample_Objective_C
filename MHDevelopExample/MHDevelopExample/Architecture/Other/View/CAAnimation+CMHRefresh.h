//
//  CAAnimation+CMHRefresh.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CMHRefresh)
/// 旋转动画
+ (CABasicAnimation *)cmh_rotationAnimation;
/// 旋转一个 开始角度 旋转到 结束角度
+ (CABasicAnimation *) cmh_rotaAnimStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
@end
