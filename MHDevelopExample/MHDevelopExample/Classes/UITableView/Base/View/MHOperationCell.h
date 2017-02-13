//
//  MHOperationCell.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/10.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  多选删除 以及 删除 的 操作的cell

#import <UIKit/UIKit.h>

@interface MHOperationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** indexPath */
@property (nonatomic , strong) NSIndexPath *indexPath;

/** 是否修改系统选中按钮的样式 */
@property (nonatomic , assign , getter = isModifySelectionStyle) BOOL modifySelectionStyle;

@end
