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
        // 由于这里只是评论一个视频
        _mediabase_id = @"89757";
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
    attributedString.yy_lineSpacing = MHCommentContentLineSpacing;
    return attributedString;
}

#pragma mark - Setter

- (void)setThumbNums:(long long)thumbNums
{
    _thumbNums = thumbNums;
    
    self.thumbNumsString = [self _thumbNumsStringWithThumbNums:thumbNums];
}

#pragma mark - Getter
- (NSString *)creatTime
{
    NSDateFormatter *fmt = [NSDateFormatter mh_defaultDateFormatter];
#warning CoderMikeHe: 真机调试的时候，必须加上这句
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 获得发布的具体时间
    NSDate *createDate = [fmt dateFromString:_creatTime];
    
    // 判断是否为今年
    if (createDate.mh_isThisYear) {
        if (createDate.mh_isToday) { // 今天
            NSDateComponents *cmps = [createDate mh_deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        } else if (createDate.mh_isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 至少是前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }

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
