//
//  MHTopicLabel.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicLabel.h"

@implementation MHTopicLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = [UIColor colorWithRed:MHTopicLabelRed green:MHTopicLabelGreen blue:MHTopicLabelBlue alpha:1.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    //      R G B
    // 默认：0.4 0.6 0.7
    // 红色：1   0   0
    
    CGFloat red = MHTopicLabelRed + (1 - MHTopicLabelRed) * scale;
    CGFloat green = MHTopicLabelGreen + (0 - MHTopicLabelGreen) * scale;
    CGFloat blue = MHTopicLabelBlue + (0 - MHTopicLabelBlue) * scale;
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0.3; // [1, 1.3]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}
@end
