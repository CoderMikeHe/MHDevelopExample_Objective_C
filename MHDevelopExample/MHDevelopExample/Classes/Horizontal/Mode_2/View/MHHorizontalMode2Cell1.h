//
//  MHHorizontalMode2Cell1.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/26.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//  cell内部嵌套collectionView ，其colletionViewCell样式 <1个黑块 == 一个Cell> 即：MHHorizontalMode1Cell + UICollectionViewFlowLayout

#import <UIKit/UIKit.h>
#import "MHHorizontalCellDelegate.h"
@class MHHorizontalGroup;
NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontalMode2Cell1 : UICollectionViewCell
/// horizontals
@property (nonatomic, readwrite, strong) MHHorizontalGroup *group;
/// delegate
@property (nonatomic, readwrite, weak) id<MHHorizontalCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
