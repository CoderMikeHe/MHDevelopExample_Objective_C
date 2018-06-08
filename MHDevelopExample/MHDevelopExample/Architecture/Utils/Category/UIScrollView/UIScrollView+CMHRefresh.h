//
//  UIScrollView+CMHRefresh.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
@interface UIScrollView (CMHRefresh)
/// 添加下拉刷新控件
- (MJRefreshHeader *)cmh_addHeaderRefresh:(void(^)(MJRefreshHeader *header))refreshingBlock;
/// 添加上拉加载控件
- (MJRefreshFooter *)cmh_addFooterRefresh:(void(^)(MJRefreshFooter *footer))refreshingBlock;
@end
