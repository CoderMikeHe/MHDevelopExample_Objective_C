//
//  CMHOperationToolBar.h
//  UTrading
//
//  Created by lx on 2018/4/20.
//  Copyright © 2018年 cqgk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMHOperationToolBarItem.h"


/// 类型
typedef NS_ENUM(NSUInteger, CMHOperationToolBarType) {
    CMHOperationToolBarTypeCheckAll = 0, /// 全选 default
    CMHOperationToolBarTypeCooperation,  /// 协作
    CMHOperationToolBarTypeTransfer,     /// 转让
    CMHOperationToolBarTypeDelete,       /// 删除  default
};

/// 显示类型
typedef NS_ENUM(NSUInteger, CMHOperationToolBarShowType) {
    CMHOperationToolBarShowTypeFootmark,  /// 足迹
    CMHOperationToolBarShowTypeCollect,   /// 收藏
};



@interface CMHOperationToolBar : UIView
/// 构造函数
///
/// @param completed 完成回调
///
/// @return 撰写类型视图
- (instancetype)initWithShowType:(CMHOperationToolBarShowType)showType selectedOperationType:(void (^)(CMHOperationToolBarType type))completed;

/// 删除
@property (nonatomic , readonly , weak) CMHOperationToolBarItem *deleteItem;

/// 全选btn
@property (nonatomic , readonly , weak) CMHOperationToolBarItem *checkAllItem;
@end
