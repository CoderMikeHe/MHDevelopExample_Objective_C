//
//  MHHorizontalCellDelegate.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/20.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MHHorizontalCellDelegate <NSObject>

@optional

/// 点击事件
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell;


/// 点击事件 tapTag == 按钮的tag
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell selectedIndex:(NSInteger)selectedIndex;


/**
 *  联动 PageTitleView 的方法
 *
 *  @param collectionViewCell         cell
 *  @param progress                   内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)collectionViewCell:(UICollectionViewCell *)cell progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex;

/// 点击事件
- (void)collectionViewCellTapAction:(UICollectionViewCell *)cell sourceData:(id)sourceData;
@end

NS_ASSUME_NONNULL_END


