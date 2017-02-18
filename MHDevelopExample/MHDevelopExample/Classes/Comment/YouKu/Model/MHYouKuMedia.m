//
//  MHYouKuMedia.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuMedia.h"

@implementation MHYouKuMedia

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mediabase_id = @"89757";
        _mediaTitle = @"仙剑奇侠传 第1集";
        _mediaContent = @"本剧讲述了渝州城永安当的小伙计景天和唐门大小姐雪见受到两人随身玉佩的彼此吸引，他们二人“热闹而又尴尬”地相识了，成了一对欢喜冤家。其实雪见和景天正是彼此的有缘人，而他们都来历不凡，身藏几世的秘密，随着雪见家族的剧变，二人阴差阳错地步入了江湖的血雨腥风之中，并结识了徐长卿、紫萱和龙葵等人，而等待他们的则是更加惊险的前程和重大的责任...";
    }
    return self;
}


#pragma mark - Setter

- (void) setThumbNums:(long long)thumbNums
{
    _thumbNums = thumbNums;
    
    _thumbNumsString = [self _numsStringWithNums:thumbNums];
}

- (void) setCommentNums:(long long)commentNums
{
    _commentNums = commentNums;
    _commentNumsString = [self _numsStringWithNums:commentNums];
}

- (void) setMediaScanTotal:(long long)mediaScanTotal
{
    _mediaScanTotal = mediaScanTotal;
    
    _mediaScanTotalString = [self _numsStringWithNums:mediaScanTotal];
}


#pragma mark - 辅助模型
- (NSString *)_numsStringWithNums:(long long)nums
{
    NSString *titleString = nil;
    
    if (nums >= 10000) { // 上万
        CGFloat final = nums / 10000.0;
        titleString = [NSString stringWithFormat:@"%.1f万", final];
        // 替换.0为空串
        titleString = [titleString stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (nums >= 0) { // 一万以内
        titleString = [NSString stringWithFormat:@"%lld", nums];
    }
    
    return titleString;
}
@end
