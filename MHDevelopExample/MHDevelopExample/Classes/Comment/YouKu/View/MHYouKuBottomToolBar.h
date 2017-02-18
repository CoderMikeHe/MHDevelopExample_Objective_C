//
//  MHYouKuBottomToolBar.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MHYouKuBottomToolBar,MHYouKuMedia;

typedef NS_ENUM(NSUInteger, MHYouKuBottomToolBarType) {
    MHYouKuBottomToolBarTypeThumb = 10, // 点赞
    MHYouKuBottomToolBarTypeComment,   // 评论
    MHYouKuBottomToolBarTypeCollect,   // 收藏
    MHYouKuBottomToolBarTypeDownload,  // 下载
    MHYouKuBottomToolBarTypeShare      // 分享
};


@protocol MHYouKuBottomToolBarDelegate <NSObject>

@optional
- (void)bottomToolBar:(MHYouKuBottomToolBar *)bottomToolBar didClickedButtonWithType:(MHYouKuBottomToolBarType)type;

@end


@interface MHYouKuBottomToolBar : UIView


/** 代理 */
@property (nonatomic , weak) id <MHYouKuBottomToolBarDelegate> delegate;

/** 模型 */
@property (nonatomic , strong) MHYouKuMedia *media;

@end
