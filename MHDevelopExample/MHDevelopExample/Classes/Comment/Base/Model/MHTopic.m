//
//  MHTopic.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/8.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopic.h"

@interface MHTopic ()

/** 点赞数string */
@property (nonatomic , copy) NSString * thumbNumsString;

@end

@implementation MHTopic

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        _comments = [NSMutableArray array];
    }
    return self;
}


#pragma mark - 公共方法

- (NSAttributedString *)attributedText
{
    if (self.text == nil) return nil;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    attributedString.yy_font = MHFont(MHPxConvertPt(15.0f), NO);
    attributedString.yy_color = MHGlobalBlackTextColor;
    attributedString.yy_lineSpacing = MHVideoCommentContentLineSpacing;
    return attributedString;
}

#pragma mark - Setter

- (void)setThumbNums:(long long)thumbNums
{
    _thumbNums = thumbNums;
    
    self.thumbNumsString = [self _thumbNumsStringWithThumbNums:thumbNums];
}



#pragma mark - 私有方法
// 点赞
- (NSString *)_thumbNumsStringWithThumbNums:(long long)thumbNums
{
    NSString *titleString = nil;
    
    if (thumbNums >= 10000) { // 上万
        CGFloat final = thumbNums / 10000.0;
        titleString = [NSString stringWithFormat:@"%.1f万", final];
        // 替换.0为空串
        titleString = [titleString stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (thumbNums > 0) { // 一万以内
        titleString = [NSString stringWithFormat:@"%lld", thumbNums];
    }
    
    return titleString;
}

@end
