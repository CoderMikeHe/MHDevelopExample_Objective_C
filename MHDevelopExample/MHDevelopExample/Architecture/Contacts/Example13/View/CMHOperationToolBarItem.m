//
//  CMHOperationToolBarItem.m
//  UTrading
//
//  Created by lx on 2018/4/20.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//

#import "CMHOperationToolBarItem.h"

@implementation CMHOperationToolBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = MHRegularFont_12;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat inner = 4;
    
    CGFloat H = self.imageView.mh_height + inner + self.titleLabel.mh_height;
    
    /// 布局图片
    self.imageView.mh_y = (self.mh_height - H) * .5f;
    self.imageView.mh_centerX = self.frame.size.width * .5f;
    
    /// 布局文字
    self.titleLabel.mh_centerX = self.frame.size.width * .5f;;
    self.titleLabel.mh_y = self.imageView.mh_bottom + inner;
}
@end
