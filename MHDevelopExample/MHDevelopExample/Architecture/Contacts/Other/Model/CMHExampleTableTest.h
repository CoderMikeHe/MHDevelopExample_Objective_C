//
//  CMHExampleTableTest.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/8.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"

@interface CMHExampleTableTest : CMHObject

/// title
@property (nonatomic , readwrite , copy) NSString *title;

/// idNum
@property (nonatomic , readwrite , assign) NSInteger idNum;


#pragma mark - 辅助属性
/// 是否是编辑状态 默认是NO
@property (nonatomic , readwrite , assign , getter = isEditState) BOOL editState;
/// 是否是选中状态 默认是NO
@property (nonatomic , readwrite , assign , getter = isSelected) BOOL selected;
@end
