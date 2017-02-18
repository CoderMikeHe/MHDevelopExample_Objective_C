//
//  MHYouKuAnthologyItem.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuItem.h"

// =========== 视频推荐  ===========
typedef NS_ENUM(NSUInteger, MHYouKuAnthologyDisplayType) {
    MHYouKuAnthologyDisplayTypeTextPlain = 1, // 文字
    MHYouKuAnthologyDisplayTypePicture = 2,   // 图片
};


@interface MHYouKuAnthology : NSObject
/** mediabase_id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 序号 */
@property (nonatomic , assign) NSInteger albums_sort ;


@end


@interface MHYouKuAnthologyItem : MHYouKuItem

/** mediabase_id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 选集列表 */
@property (nonatomic , strong) NSMutableArray *anthologys;

/** 显示类型 */
@property (nonatomic , assign) MHYouKuAnthologyDisplayType displayType;

/** 第一次加载的位置 位置 */
@property (nonatomic , assign) NSInteger item;
@end
