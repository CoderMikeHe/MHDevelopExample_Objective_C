//
//  CMHConfigureCell.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMHConfigureView.h"

@protocol CMHConfigureCell <NSObject,CMHConfigureView>
@optional
///
/// 传递indexPath,且告诉该组(section)有多少行（row）
///
/// @param indexPath the indexPath.
/// @param rows the group have rows count.
///
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSInteger)rows;
@end
