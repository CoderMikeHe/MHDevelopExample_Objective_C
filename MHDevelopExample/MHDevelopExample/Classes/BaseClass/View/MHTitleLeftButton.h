//
//  MHTitleLeftButton.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
/**
___________________
|  文字   |  图片   |
-------------------
 */

#import <UIKit/UIKit.h>

@interface MHTitleLeftButton : UIButton
/** 文字和图片的间距 */
@property (nonatomic , assign) CGFloat margin;
/** 文字偏移最左侧的间距 */
@property (nonatomic , assign) CGFloat titleOffsetX;
@end
