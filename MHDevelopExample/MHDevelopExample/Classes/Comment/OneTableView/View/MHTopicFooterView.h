//
//  MHTopicFooterView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTopicFooterView : UITableViewHeaderFooterView
+ (instancetype)videoTopicFooterView;
+ (instancetype)footerViewWithTableView:(UITableView *)tableView;
- (void)setSection:(NSInteger)section allSections:(NSInteger)sections;
@end
