//
//  CMHTableViewCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/2.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHTableViewCell.h"

@implementation CMHTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CMHTableViewCell";
    CMHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
