//
//  MHYouKuInputPanelView.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHCommentReply,MHYouKuInputPanelView;

@protocol MHYouKuInputPanelViewDelegate <NSObject>

@optional
- (void)inputPanelView:(MHYouKuInputPanelView *)inputPanelView attributedText:(NSString *)attributedText;

@end


@interface MHYouKuInputPanelView : UIView


/** 回复评论 */
@property (nonatomic , strong) MHCommentReply *commentReply;

/** 代理 */
@property (nonatomic , weak) id <MHYouKuInputPanelViewDelegate> delegate;


+ (instancetype)inputPanelView;

/** 显示 */
- (void) show;

/** 是否人为dismiss */
- (void) dismissByUser:(BOOL)state;
@end
