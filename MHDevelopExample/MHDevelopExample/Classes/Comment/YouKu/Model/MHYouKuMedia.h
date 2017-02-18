//
//  MHYouKuMedia.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHYouKuMedia : NSObject

/** 视频id */
@property (nonatomic , copy) NSString *mediabase_id;

/** 视频链接 */
@property (nonatomic , copy) NSString *mediaUrl;

/** 赞数 */
@property (nonatomic , assign) long long thumbNums;
/** 点赞数据string */
@property (nonatomic , copy , readonly) NSString *thumbNumsString ;

/** 是否点赞 */
@property (nonatomic , assign , getter = isThumb) BOOL thumb;

/** 评论数 */
@property (nonatomic , assign) long long commentNums;
/** 评论数string */
@property (nonatomic , copy , readonly) NSString * commentNumsString;

/** 收藏 */
@property (nonatomic , assign , getter = isCollect) BOOL collect;


/** 浏览量 */
@property (nonatomic , assign) long long mediaScanTotal;
/** 浏览量string */
@property (nonatomic , copy , readonly) NSString *mediaScanTotalString;

/** 视频名称 */
@property (nonatomic , copy) NSString *mediaTitle;
/** 视频详情 */
@property (nonatomic , copy) NSString *mediaContent;

/** 创建时间 */
@property (nonatomic , copy) NSString *creatTime;

@end
