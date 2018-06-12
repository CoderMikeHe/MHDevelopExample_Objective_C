//
//  Card.h
//  CardSwitchDemo
//
//  Created by Apple on 2016/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//  被切换的卡片

#import <UIKit/UIKit.h>
#import "XLCardItem.h"

@interface XLCard : UICollectionViewCell

@property (nonatomic, strong) XLCardItem *item;

@end
