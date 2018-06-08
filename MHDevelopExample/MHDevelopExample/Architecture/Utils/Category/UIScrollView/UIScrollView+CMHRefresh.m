//
//  UIScrollView+CMHRefresh.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "UIScrollView+CMHRefresh.h"
#import "CMHRefreshHeader.h"
#import "CMHRefreshFooter.h"
@implementation UIScrollView (CMHRefresh)
/// 添加下拉刷新控件
- (MJRefreshHeader *)cmh_addHeaderRefresh:(void(^)(MJRefreshHeader *header))refreshingBlock {
    
    __weak typeof(&*self) weakSelf = self;
    CMHRefreshHeader *mj_header = [CMHRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshNormalHeader *)strongSelf.mj_header);
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    mj_header.automaticallyChangeAlpha = YES;
    // Configure normal mj_header
    self.mj_header = mj_header;
    return mj_header;
}

/// 添加上拉加载控件
- (MJRefreshFooter *)cmh_addFooterRefresh:(void(^)(MJRefreshFooter *footer))refreshingBlock {
    __weak typeof(&*self) weakSelf = self;
    CMHRefreshFooter *mj_footer = [CMHRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshAutoNormalFooter *)strongSelf.mj_footer);
    }];
    self.mj_footer = mj_footer;
    return mj_footer;
}

@end
