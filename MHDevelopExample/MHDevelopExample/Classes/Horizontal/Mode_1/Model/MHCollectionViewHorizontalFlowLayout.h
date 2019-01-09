//
//  MHCollectionViewHorizontalFlowLayout.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/27.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHCollectionViewHorizontalFlowLayout : UICollectionViewFlowLayout

/// 行数 default is 1
@property (nonatomic, readwrite, assign) NSInteger rowCount;

/// 列数 default is 1
@property (nonatomic, readwrite, assign) NSInteger columnCount;

/** 以下三个属性定义
 /// 行间距
 @property (nonatomic) CGFloat minimumLineSpacing;
 /// 列间距
 @property (nonatomic) CGFloat minimumInteritemSpacing;
 /// 页边距
 @property (nonatomic) UIEdgeInsets sectionInset;
 */
@end

NS_ASSUME_NONNULL_END
