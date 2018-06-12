//
//  CMHSearchHistoryHeaderView.h
//  UTrading
//
//  Created by lx on 2018/4/23.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMHSearchHistoryHeaderView;

@protocol CMHSearchHistoryHeaderViewDelegate <NSObject>
/// 删除按钮
- (void)searchHistoryHeaderViewDidClickedDeleteItem:(CMHSearchHistoryHeaderView *)searchHistoryHeaderView;
@end

@interface CMHSearchHistoryHeaderView : UICollectionReusableView

/// delegate
@property (nonatomic , readwrite , weak) id <CMHSearchHistoryHeaderViewDelegate>delegate;

@end
