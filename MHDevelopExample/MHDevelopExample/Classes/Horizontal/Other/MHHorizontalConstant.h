//
//  MHHorizontalConstant.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/18.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 每页数据个数
FOUNDATION_EXTERN NSInteger const MHHorizontalPageSize ;


/// 内容Inset
static inline UIEdgeInsets MHHorizontalSectionInset(){
    return UIEdgeInsetsMake(30, 10, 30, 10);
}

/// 列间隙
FOUNDATION_EXTERN CGFloat const MHHorizontalMinimumInteritemSpacing ;

/// 行间距
FOUNDATION_EXTERN CGFloat const MHHorizontalMinimumLineSpacing;

/// 最大行数
FOUNDATION_EXTERN NSUInteger const MHHorizontalMaxRow ;

/// 最大列数
FOUNDATION_EXTERN NSUInteger const MHHorizontalMaxColumn ;

NS_ASSUME_NONNULL_END
