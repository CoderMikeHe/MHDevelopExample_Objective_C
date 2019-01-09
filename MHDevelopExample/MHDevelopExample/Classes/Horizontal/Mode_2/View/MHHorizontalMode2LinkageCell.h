//
//  MHHorizontalMode2LinkageCell.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/27.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHHorizontalCellDelegate.h"
@class MHHorizontalGroup;
NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontalMode2LinkageCell : UICollectionViewCell
/// horizontals
@property (nonatomic, readwrite, strong) MHHorizontalGroup *group;
/// delegate
@property (nonatomic, readwrite, weak) id<MHHorizontalCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
