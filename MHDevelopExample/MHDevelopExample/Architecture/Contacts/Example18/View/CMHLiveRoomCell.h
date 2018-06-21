//
//  CMHLiveRoomCell.h
//  WeChat
//
//  Created by senba on 2017/10/20.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CMHLiveRoomCell : UITableViewCell<CMHConfigureView>
/// 返回cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
