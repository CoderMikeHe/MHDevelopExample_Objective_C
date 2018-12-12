//
//  MHTitleRightButton.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
/**
 _________________
|  图片   |  文字  |
 -----------------
 */

#import <UIKit/UIKit.h>

@interface MHTitleRightButton : UIButton

/** 文字和图片的间距 */
@property (nonatomic , assign) CGFloat margin;
/** 图片偏移最左侧的间距 */
@property (nonatomic , assign) CGFloat imageOffsetX;

@end
