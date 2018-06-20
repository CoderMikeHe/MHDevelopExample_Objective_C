//
//  UIView+CMHEmptyView.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/19.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMHEmptyDataView.h"

@interface UIView (CMHEmptyView)

/// emptyDataView
@property (nonatomic , readwrite , strong) CMHEmptyDataView *emptyDataView;

/**
 无数据显示友好文本提示视图
 @param type 显示类型
 @param emptyInfo 无数据时提示文字信息，不传则为默认；前提是 hasData = NO && hasError = NO
 @param errorInfo 无数据且请求错误时提示文字信息，不传则为默认；前提是 hasData = NO && hasError = YES
 @param offsetTop 显示的图片的中心点Y值距离其父类视图的顶部的距离
 @param hasData  是否存在数据
 @param hasError 是否存在错误
 @param reloadBlock 如果有加载按钮点击的回调
 */
- (void)cmh_configEmptyViewWithType:(CMHEmptyDataViewType)type emptyInfo:(NSString *)emptyInfo errorInfo:(NSString *)errorInfo offsetTop:(CGFloat)offsetTop hasData:(BOOL)hasData hasError:(BOOL)hasError reloadBlock:(void(^)(void))reloadBlock;
@end
