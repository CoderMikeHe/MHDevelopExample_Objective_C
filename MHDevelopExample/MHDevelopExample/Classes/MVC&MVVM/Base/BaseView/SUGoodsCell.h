//
//  SUGoodsCell.h
//  SenbaUsed
//
//  Created by shiba_iOSRB on 16/7/26.
//  Copyright © 2016年 曾维俊. All rights reserved.
//
// Goods cell

#import <UIKit/UIKit.h>

#import "SUReactiveView.h"

//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
@class SUGoodsFrame,SUGoodsCell;
//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore


//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/**
 * 图片被点击
 */
typedef void(^SUGoodsCellPictureClickedHandler)(SUGoodsCell *goodsCell);
/**
 * 头像被点击
 */
typedef void(^SUGoodsCellAvatarClickedHandler)(SUGoodsCell *goodsCell);

/**
 * 位置被点击
 */
typedef void(^SUGoodsCellLocationClickedHandler)(SUGoodsCell *goodsCell);

/**
 * 留言被点击
 */
typedef void(^SUGoodsCellReplyClickedHandler)(SUGoodsCell *goodsCell);

/**
 * 点赞被点击
 */
typedef void(^SUGoodsCellThumbClickedHandler)(SUGoodsCell *goodsCell);

/**
 * 商品图片view被点击
 */
typedef void(^SUGoodsCellPictureViewClickedHandler)(SUGoodsCell *goodsCell);
//// 以上 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore



@interface SUGoodsCell : UITableViewCell<SUReactiveView>



//// 以下 MVC使用的场景，如果使用MVVM的请自行ignore
/// 商品
@property (nonatomic, readwrite, strong) SUGoodsFrame *goodsFrame;
//// 以上 MVC使用的场景，如果使用MVVM的请自行ignore



//// 以下 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore
/// 事件处理 我这里使用 block 来回调事件 （PS：大家可以自行决定）
/// 头像点击callBack
@property (nonatomic, readwrite, copy) SUGoodsCellAvatarClickedHandler avatarClickedHandler;
/// 位置按钮被点击
@property (nonatomic, readwrite, copy) SUGoodsCellLocationClickedHandler locationClickedHandler;
/// 回复按钮被点击
@property (nonatomic, readwrite, copy) SUGoodsCellReplyClickedHandler replyClickedHandler;
/// 点赞按钮被点击
@property (nonatomic, readwrite, copy) SUGoodsCellThumbClickedHandler thumbClickedHandler;
/// 商品照片view被点击
@property (nonatomic, readwrite, copy) SUGoodsCellPictureViewClickedHandler pictureViewClickedHandler;
//// 以上 MVC 和 MVVM without RAC 的事件回调的使用的场景，如果使用MVVM With RAC的请自行ignore

@end
