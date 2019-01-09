//
//  MHHorizontalEmptyCell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/25.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalEmptyCell.h"

@implementation MHHorizontalEmptyCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
