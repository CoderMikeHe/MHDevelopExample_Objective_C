//
//  MHComment.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHComment.h"

@implementation MHComment
- (NSAttributedString *)attributedText
{
    // 这个属性是  仿优酷视频评论，不是仿优酷的请自行忽略
    if ([self.commentId isEqualToString:MHVideoAllCommentsId]) {
        
        // 测试数据
        NSString *textString = [NSString stringWithFormat:@"%@",self.text];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.yy_font = MHVideoCommentTextFont;
        mutableAttributedString.yy_color = MHGlobalOrangeTextColor;
        mutableAttributedString.yy_lineSpacing = MHVideoCommentContentLineSpacing;
        
        return mutableAttributedString;
    }
    
    
    if (!MHObjectIsNil(self.toUser) && self.toUser.nickname.length>0) {
        // 有回复
        NSString *textString = [NSString stringWithFormat:@"%@回复%@: %@", self.fromUser.nickname, self.toUser.nickname, self.text];;
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.yy_font = MHVideoCommentTextFont;
        mutableAttributedString.yy_color = MHGlobalBlackTextColor;
        mutableAttributedString.yy_lineSpacing = MHVideoCommentContentLineSpacing;
        // 设置昵称颜色
        [mutableAttributedString yy_setColor:MHGlobalGrayTextColor range:NSMakeRange(0, self.fromUser.nickname.length+1)];
        
        NSRange range = [textString rangeOfString:[NSString stringWithFormat:@"%@:",self.toUser.nickname]];
        [mutableAttributedString yy_setColor:MHGlobalGrayTextColor range:range];
        
        return mutableAttributedString;
        
        
    }else{
        
        // 没有回复
        NSString *textString = [NSString stringWithFormat:@"%@: %@", self.fromUser.nickname, self.text];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.yy_font = MHVideoCommentTextFont;
        mutableAttributedString.yy_color = MHGlobalBlackTextColor;
        mutableAttributedString.yy_lineSpacing = MHVideoCommentContentLineSpacing;
        // 设置昵称颜色
        [mutableAttributedString yy_setColor:MHGlobalGrayTextColor range:NSMakeRange(0, self.fromUser.nickname.length+1)];
        
        return mutableAttributedString;
    }
    
    return nil;
}

@end
