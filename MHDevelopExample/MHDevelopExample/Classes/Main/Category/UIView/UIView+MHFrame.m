//
//  UIView+MHFrame.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIView+MHFrame.h"

@implementation UIView (MHFrame)

- (void)setMh_x:(CGFloat)mh_x
{
    CGRect frame = self.frame;
    frame.origin.x = mh_x;
    self.frame = frame;
}
- (CGFloat)mh_x
{
    return self.frame.origin.x;
}




- (void)setMh_y:(CGFloat)mh_y
{
    CGRect frame = self.frame;
    frame.origin.y = mh_y;
    self.frame = frame;
}
- (CGFloat)mh_y
{
    return self.frame.origin.y;
}







- (void)setMh_centerX:(CGFloat)mh_centerX
{
    CGPoint center = self.center;
    center.x = mh_centerX;
    self.center = center;
}
- (CGFloat)mh_centerX
{
    return self.center.x;
}



- (void)setMh_centerY:(CGFloat)mh_centerY
{
    CGPoint center = self.center;
    center.y = mh_centerY;
    self.center = center;
}
- (CGFloat)mh_centerY
{
    return self.center.y;
}




- (void)setMh_width:(CGFloat)mh_width
{
    CGRect frame = self.frame;
    frame.size.width = mh_width;
    self.frame = frame;
}
- (CGFloat)mh_width
{
    return self.frame.size.width;
}





- (void)setMh_height:(CGFloat)mh_height
{
    CGRect frame = self.frame;
    frame.size.height = mh_height;
    self.frame = frame;
}
- (CGFloat)mh_height
{
    return self.frame.size.height;
}





- (void)setMh_size:(CGSize)mh_size
{
    CGRect frame = self.frame;
    frame.size = mh_size;
    self.frame = frame;
}
- (CGSize)mh_size
{
    return self.frame.size;
}



@end
