//
//  SUSearchBarView.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUSearchBarView.h"



@interface SUSearchBarView()
/// icon
@property (nonatomic, readwrite, weak)   UIImageView *imageView;
/// tipsLabel
@property (nonatomic, readwrite, weak)   UILabel *tipsLabel;
@end

@implementation SUSearchBarView

+ (instancetype)searchBarView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = MHColorFromHexString(@"#e8eaf1");
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        
        /// search icon
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
        [imageView sizeToFit];
        self.imageView = imageView;
        [self addSubview:imageView];
        
        /// tipsLabel
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.font = MHRegularFont_14;
        tipsLabel.textColor = MHColorFromHexString(@"#747a8e");
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.text = self.tips;
        [self.tipsLabel sizeToFit];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel = tipsLabel;
        [self addSubview:tipsLabel];

        /// 添加手势
        @weakify(self);
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            @strongify(self);
            !self.searchBarViewClicked?:self.searchBarViewClicked();
        }]];
        
        /// 设置数据
        self.tips = SUSearchTipsText;
    }
    return self;
}

- (void)setTips:(NSString *)tips {
    _tips = tips;
    self.tipsLabel.text = tips;
    [self.tipsLabel setNeedsDisplay];
    [self.tipsLabel sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageViewInset = 10;
    self.tipsLabel.mh_centerX = ceil(self.mh_width * 0.5) + imageViewInset;
    self.tipsLabel.mh_y = floor((self.mh_height - self.tipsLabel.mh_height)/2);
    
    self.imageView.mh_centerY = self.tipsLabel.mh_centerY;
    self.imageView.mh_x = self.tipsLabel.mh_x - imageViewInset - self.imageView.mh_width;
}

@end
