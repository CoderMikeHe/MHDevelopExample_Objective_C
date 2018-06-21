//
//  CMHLiveRoom.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/21.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHLiveRoom.h"

@interface CMHLiveRoom ()
/// cellHeight
@property (nonatomic, readwrite, assign) CGFloat cellHeight;
/// girlStar
@property (nonatomic, readwrite, copy) NSString *girlStar;
/// 观众人数
@property (nonatomic, readwrite, copy) NSAttributedString *allNumAttr;
@end

@implementation CMHLiveRoom
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"list":[CMHLiveRoom class]};
}

- (void)setStarlevel:(NSInteger)starlevel{
    _starlevel = starlevel;
    self.girlStar = [NSString stringWithFormat:@"girl_star%zd_40x19", starlevel];
}

- (void)setAllnum:(NSString *)allnum{
    _allnum = allnum.copy;
    NSMutableAttributedString *allNumAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@人在看",allnum]];
    allNumAttr.yy_font = MHRegularFont_17;
    allNumAttr.yy_color = MHColorFromHexString(@"#999999");
    allNumAttr.yy_alignment = NSTextAlignmentRight;
    [allNumAttr yy_setColor:MHColorFromHexString(@"#F14F94") range:NSMakeRange(0, allnum.length)];
    self.allNumAttr = allNumAttr.copy;
}


- (CGFloat)cellHeight{
    return 50 + MH_SCREEN_WIDTH + 7;
}

@end
