//
//  MHYouKuCommentToolBar.h
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHYouKuCommentToolBar;

@protocol MHYouKuCommentToolBarDelegate <NSObject>

@optional

// 发送按钮被点击
- (void) commentToolBarForSendAction:(MHYouKuCommentToolBar *)commentToolBar;
@end


@interface MHYouKuCommentToolBar : UIView
/** 代理 */
@property (nonatomic , weak) id <MHYouKuCommentToolBarDelegate> delegate;

/** 初始化 */
+ (instancetype)commentToolBar;

/** 文字改变 */
- (void) textDidChanged:(YYTextView *)textView;
@end
