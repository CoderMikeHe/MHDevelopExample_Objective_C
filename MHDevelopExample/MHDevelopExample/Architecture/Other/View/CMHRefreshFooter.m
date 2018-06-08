//
//  CMHRefreshFooter.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHRefreshFooter.h"
#import "CAAnimation+CMHRefresh.h"
@interface CMHRefreshFooter ()
/// logo
@property (nonatomic , readwrite , weak) UIImageView *loadingView;

@end



@implementation CMHRefreshFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    /// logo
    UIImageView * loadingView = [[UIImageView alloc] initWithImage:MHImageNamed(@"loading_animation")];
    self.loadingView = loadingView;
    [self addSubview:loadingView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        loadingCenterX -= self.stateLabel.mj_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    /*
     ** 普通闲置状态 *
     MJRefreshStateIdle = 1,
     ** 松开就可以进行刷新的状态 *
     MJRefreshStatePulling,
     ** 正在刷新中的状态 *
     MJRefreshStateRefreshing,
     ** 即将刷新的状态 *
     MJRefreshStateWillRefresh,
     ** 所有数据加载完毕，没有更多的数据了 *
     MJRefreshStateNoMoreData
     */
    switch (state) {
        case MJRefreshStateIdle:
            [self.loadingView.layer removeAllAnimations];  /// 
            break;
        case MJRefreshStatePulling:
            [self.loadingView.layer removeAllAnimations];
            break;
        case MJRefreshStateRefreshing:
            [self.loadingView.layer addAnimation:[CAAnimation cmh_rotationAnimation] forKey:@"cmh_rotationAnimation"];
            break;
        default:
            break;
    }
}
@end
