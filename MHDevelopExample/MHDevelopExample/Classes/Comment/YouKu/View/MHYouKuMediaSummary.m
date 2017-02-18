//
//  MHYouKuMediaSummary.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuMediaSummary.h"
#import "MHYouKuMedia.h"
#import "MHTitleLeftButton.h"
#import "MHTitleRightButton.h"

@interface MHYouKuMediaSummary ()

/** 主题 */
@property (nonatomic , weak) UILabel *title;

/** 详情 */
@property (nonatomic , weak) MHTitleLeftButton *detailBtn;

/** 播放量 */
@property (nonatomic , weak) MHTitleRightButton *playNumsBtn;

/** 上传时间 */
@property (nonatomic , weak) UILabel *creatTime;

/** bottomLine */
@property (nonatomic , weak) MHDivider *bottomSeparate;

@end


@implementation MHYouKuMediaSummary

+ (instancetype)summary
{
    return [[self alloc] init];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}
- (void)setMedia:(MHYouKuMedia *)media
{
    _media = media;
    
    // 主题
    self.title.text = media.mediaTitle;
    
    // 浏览量
    [self.playNumsBtn setTitle:[NSString stringWithFormat:@"%@次播放",media.mediaScanTotalString] forState:UIControlStateNormal];
    
    // 更新时间
    self.creatTime.text = [NSString stringWithFormat:@"%@",[media.creatTime componentsSeparatedByString:@" "].firstObject];
}

#pragma mark - 创建子控件
- (void)_setupSubViews
{
    // 主题
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 1;
    title.textColor = MHGlobalBlackTextColor;
    title.font = MHFont(MHPxConvertPt(15.0f), NO);
    title.backgroundColor = [UIColor clearColor];
    self.title = title;
    [self addSubview:title];
    
    // 详情
    MHTitleLeftButton *detailBtn = [[MHTitleLeftButton alloc] init];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateNormal];
    [detailBtn setImage:[UIImage imageNamed:@"playerRecommend_rightArrow"] forState:UIControlStateNormal];
    detailBtn.titleOffsetX = 0;
    detailBtn.margin = 5;
    detailBtn.titleLabel.font = MHFont(12.0f, NO);
    
    [detailBtn addTarget:self action:@selector(_detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    self.detailBtn = detailBtn;
    
    // 播放量
    MHTitleRightButton *playNumsBtn = [[MHTitleRightButton alloc] init];
    playNumsBtn.userInteractionEnabled = YES;
    [playNumsBtn setTitleColor:MHGlobalGrayTextColor forState:UIControlStateNormal];
    [playNumsBtn setImage:[UIImage imageNamed:@"CollectionVideo_playNums"] forState:UIControlStateNormal];
    playNumsBtn.titleLabel.font = MHMediumFont(10.0f);
    playNumsBtn.backgroundColor = [UIColor clearColor];
    self.playNumsBtn = playNumsBtn;
    [self addSubview:playNumsBtn];
    
    
    // 上传时间
    UILabel *creatTime = [[UILabel alloc] init];
    creatTime.textColor = MHGlobalGrayTextColor;
    creatTime.font = MHMediumFont(10.0f);
    [self addSubview:creatTime];
    self.creatTime = creatTime;
    
    
    // 分割线
    MHDivider *bottomSeparate = [MHDivider divider];
    bottomSeparate.backgroundColor = MHColorFromHexString(@"#eeeeee");
    self.bottomSeparate = bottomSeparate;
    [self addSubview:bottomSeparate];
    
}
#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 主题
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(MHGlobalViewLeftInset);
        make.top.equalTo(self.mas_top).with.offset(MHGlobalViewTopInset);
        make.right.equalTo(self.detailBtn.mas_left).with.offset(-1 * MHGlobalViewInterInset );
        make.height.mas_equalTo(MHPxConvertPt([@"哈哈哈哈哈哈" mh_sizeWithFont:self.title.font].height));
    }];
    
    // 详情
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.title.mas_height);
        make.width.mas_equalTo(50.0f);
        make.centerY.equalTo(self.title.mas_centerY);
        
    }];
    
    // 播放字数
    [self.playNumsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_left).with.offset(0);
        make.height.mas_equalTo([@"10次播放" mh_sizeWithFont:self.playNumsBtn.titleLabel.font].height);
        make.bottom.equalTo(self.bottomSeparate.mas_top).with.offset(-1 *MHGlobalViewTopInset);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    
    // 创建时间
    [self.creatTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playNumsBtn.mas_right).with.offset(MHGlobalViewLeftInset);
        make.centerY.equalTo(self.playNumsBtn.mas_centerY);
        make.height.equalTo(self.playNumsBtn.mas_height);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    
    // 布局分割线
    [self.bottomSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(5.0f);
    }];
}


#pragma mark - 视频详情按钮点击
- (void)_detailBtnClicked:(UIButton *)sender
{
    !self.detailCallBack ? :self.detailCallBack(self);
}

@end
