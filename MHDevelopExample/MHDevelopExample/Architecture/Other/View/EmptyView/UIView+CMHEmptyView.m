//
//  UIView+CMHEmptyView.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "UIView+CMHEmptyView.h"

/// 标识 showPosterGraph
static char CMH_EMPTY_VIEW;

@implementation UIView (CMHEmptyView)

#pragma mark - Getter & Setter
- (void)setEmptyDataView:(CMHEmptyDataView *)emptyDataView{
    [self willChangeValueForKey:@"emptyDataView"];
    
    //关联对象
    objc_setAssociatedObject(self, &CMH_EMPTY_VIEW,
                             emptyDataView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self didChangeValueForKey:@"emptyDataView"];
}

- (CMHEmptyDataView *)emptyDataView{
     return objc_getAssociatedObject(self, &CMH_EMPTY_VIEW);
}


#pragma mark - Method
- (void)cmh_configEmptyViewWithType:(CMHEmptyDataViewType)type emptyInfo:(NSString *)emptyInfo errorInfo:(NSString *)errorInfo offsetTop:(CGFloat)offsetTop hasData:(BOOL)hasData hasError:(BOOL)hasError reloadBlock:(void(^)(void))reloadBlock{
    
    if (hasData) {  /// 有数据，则不需要显示占位图
        self.emptyDataView.hidden = YES;
        [self.emptyDataView removeFromSuperview];
        return;
    }
    
    /// 没有数据的情况 1. 确实没有数据  2. 请求出错导致无数据
    if (self.emptyDataView == nil) {
        /// 懒加载
        /// CoderMikeHe Fixed Bug : 这里设置`self.emptyDataView`的尺寸不要直接使用`superviewBounds`，因为`UIScrollView`的子类其`bounds`有可能不是（0 , 0 , width , height）这种值
        CGRect superviewBounds = self.bounds;
        self.emptyDataView = [[CMHEmptyDataView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(superviewBounds), CGRectGetHeight(superviewBounds))];
    }

    if (!self.emptyDataView.superview) {
        // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
        if (([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && self.subviews.count > 1) {
            [self insertSubview:self.emptyDataView atIndex:0];
        }
        else {
            [self addSubview:self.emptyDataView];
        }
    }

    self.emptyDataView.hidden = NO;
    
    /// 配置占位视图的内容
    [self.emptyDataView configEmptyViewWithType:type emptyInfo:emptyInfo errorInfo:errorInfo offsetTop:offsetTop hasData:hasData hasError:hasError reloadBlock:reloadBlock];
}


@end
