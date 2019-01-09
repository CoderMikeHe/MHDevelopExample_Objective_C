//
//  MHHorizontal.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/15.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHHorizontal : NSObject

/// idstr
@property (nonatomic, readwrite, copy) NSString *idstr;
/// Name
@property (nonatomic, readwrite, copy) NSString *name;
/// 是否选中
@property(nonatomic, readwrite, assign, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
