//
//  SUGoodsHeaderView.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUGoodsHeaderView.h"

@implementation SUGoodsHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    /// Setting the background color on UITableViewHeaderFooterView has been deprecated. Please use contentView.backgroundColor instead.
    self.contentView.backgroundColor = SUGlobalGrayBackgroundColor;
}

@end
