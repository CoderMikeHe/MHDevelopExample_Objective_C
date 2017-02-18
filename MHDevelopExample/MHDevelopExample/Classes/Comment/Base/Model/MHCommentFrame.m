//
//  MHCommentFrame.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHCommentFrame.h"

@interface MHCommentFrame ()

/** 内容尺寸 */
@property (nonatomic , assign) CGRect textFrame;
/** cell高度 */
@property (nonatomic , assign) CGFloat cellHeight;

@end


@implementation MHCommentFrame

#pragma mark - Setter

- (void)setComment:(MHComment *)comment
{
    _comment = comment;
    
    // 文本内容
    CGFloat textX = MHCommentHorizontalSpace;
    CGFloat textY = MHCommentVerticalSpace;
    CGSize  textLimitSize = CGSizeMake(self.maxW - 2 *textX, MAXFLOAT);
    CGFloat textH = [YYTextLayout layoutWithContainerSize:textLimitSize text:comment.attributedText].textBoundingSize.height;
    
    self.textFrame = (CGRect){{textX , textY} , {textLimitSize.width , textH}};
    
    self.cellHeight = CGRectGetMaxY(self.textFrame) + MHCommentVerticalSpace;
}

@end
