//
//  MHHorizontalMode0Cell.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/18.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHorizontalCellDelegate.h"
@class MHHorizontal;
NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontalMode0Cell : UICollectionViewCell

/// horizontals
@property (nonatomic, readwrite, copy) NSArray *horizontals;

/// delegate
@property (nonatomic, readwrite, weak) id<MHHorizontalCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
