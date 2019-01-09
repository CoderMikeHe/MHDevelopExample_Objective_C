//
//  MHHorizontalMode2Cell0.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/25.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//  cell内部嵌套collectionView ，colletionViewCell样式 <9个黑块 == 一个Cell> 即：MHHorizontalMode0Cell

#import <UIKit/UIKit.h>
#import "MHHorizontalCellDelegate.h"
@class MHHorizontalGroup;

NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontalMode2Cell0 : UICollectionViewCell
/// horizontals
@property (nonatomic, readwrite, strong) MHHorizontalGroup *group;
/// delegate
@property (nonatomic, readwrite, weak) id<MHHorizontalCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
