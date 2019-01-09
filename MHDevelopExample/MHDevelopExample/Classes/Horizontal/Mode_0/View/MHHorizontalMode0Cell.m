//
//  MHHorizontalMode0Cell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 2018/12/18.
//  Copyright © 2018 CoderMikeHe. All rights reserved.
//

#import "MHHorizontalMode0Cell.h"
#import "MHHorizontalConstant.h"
#import "MHHorizontal.h"
@interface MHHorizontalMode0Cell ()
@end

@implementation MHHorizontalMode0Cell

#pragma mark - Setter
- (void)setHorizontals:(NSArray *)horizontals{
    _horizontals = [horizontals copy];
    
    NSInteger count = MHHorizontalPageSize;
    NSInteger hCount = horizontals.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.contentView.subviews[i];
        if (i < hCount) {
            MHHorizontal *hz = horizontals[i];
            btn.hidden = NO;
            [btn setTitle:hz.name forState:UIControlStateNormal];
            btn.layer.borderColor = hz.isSelected ? [UIColor pinkColor].CGColor : [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = hz.isSelected ? 3 : 1;
        }else{
            btn.hidden = YES;
        }
    }
}

#pragma mark - Action
- (void)_btnDidClicked:(UIButton *)sender{
    /// 回调数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCellTapAction:selectedIndex:)]) {
        [self.delegate collectionViewCellTapAction:self selectedIndex:sender.tag];
    }
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _setup];
        
        // 创建自控制器
        [self _setupSubviews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 初始化OrUI布局
/// 初始化
- (void)_setup{
    self.backgroundColor = self.backgroundColor = [UIColor clearColor];
}

/// 创建子控件
- (void)_setupSubviews{
    /// 创建九宫格样式
    NSInteger count = MHHorizontalPageSize;
    for (NSInteger i = 0 ; i < count; i++) {
        /// label
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = MHRegularFont_16;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8f];
        [self.contentView addSubview:btn];
        /// 默认边框
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        /// 事件处理
        [btn addTarget:self action:@selector(_btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
    }
}

/// 布局子控件
- (void)_makeSubViewsConstraints{
    
}

/// 布局子控件(手写frame)
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger count = MHHorizontalPageSize;
    CGFloat rowOrCol = 3.0f;
    
    CGFloat btnW = (self.mh_width - (rowOrCol - 1)*MHHorizontalMinimumInteritemSpacing - MHHorizontalSectionInset().left - MHHorizontalSectionInset().right)/rowOrCol;
    CGFloat btnH = (self.mh_height - (rowOrCol - 1) *MHHorizontalMinimumLineSpacing - MHHorizontalSectionInset().top - MHHorizontalSectionInset().bottom)/rowOrCol;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UILabel *btn = self.contentView.subviews[i];
        CGFloat btnX = MHHorizontalSectionInset().left + (btnW + MHHorizontalMinimumInteritemSpacing) * (i % 3);
        CGFloat btnY = MHHorizontalSectionInset().top + (btnH + MHHorizontalMinimumLineSpacing) * (i / 3);;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
}

@end
