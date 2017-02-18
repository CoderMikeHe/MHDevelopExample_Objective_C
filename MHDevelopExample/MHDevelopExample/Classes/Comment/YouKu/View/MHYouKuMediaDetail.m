//
//  MHYouKuMediaDetail.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuMediaDetail.h"
#import "MHTitleRightButton.h"
#import "MHYouKuMedia.h"

@interface MHYouKuMediaDetail ()

/** 主题 */
@property (nonatomic , weak) UILabel *title;

/** 简介 **/
@property (nonatomic , weak) UILabel *summary ;

/** 点赞数量 */
@property (nonatomic , weak) MHTitleRightButton *thumbBtn;

/** 关闭 */
@property (nonatomic , weak) UIButton *closeBtn;

/** 上传时间 */
@property (nonatomic , weak) UILabel *creatTime;

/** 简介内容 **/
@property (nonatomic , weak) UILabel *content ;

/** 分割线 **/
@property (nonatomic , weak) MHImageView *separate ;

/** 文本内容 **/
@property (nonatomic , weak) UIScrollView* scrollView;


@end

@implementation MHYouKuMediaDetail

+ (instancetype)detail
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

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 简介
    UILabel *summary = [[UILabel alloc] init];
    summary.text = @"简介";
    summary.textColor = MHGlobalBlackTextColor;
    summary.font = MHMediumFont(MHPxConvertPt(15.0f));
    self.summary = summary;
    [self addSubview:summary];
    
    // 推掉
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:MHImageNamed(@"detail_close") forState:UIControlStateNormal];
    self.closeBtn = closeBtn;
    [closeBtn addTarget:self action:@selector(_closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    // 分割线
    MHImageView *separate = [MHImageView imageView];
    separate.backgroundColor = MHGlobalBottomLineColor;
    self.separate = separate;
    [self addSubview:separate];
    
    // 滚动区域
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    // 视屏主题
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.text = @"";
    title.textColor = MHGlobalGrayTextColor;
    title.font = MHMediumFont(MHPxConvertPt(13.0f));
    title.preferredMaxLayoutWidth = self.mh_width - 2 * MHGlobalViewLeftInset;
    self.title = title;
    [scrollView addSubview:title];
    
    // 视频内容
    UILabel *content = [[UILabel alloc] init];
    content.numberOfLines = 0;
    content.text = @"";
    content.textColor = title.textColor;
    content.font = title.font;
    content.preferredMaxLayoutWidth = MHMainScreenWidth-2*MHGlobalViewLeftInset;
    self.content = content;
    [scrollView addSubview:content];
    
    // 点赞数量
    MHTitleRightButton *thumbBtn = [[MHTitleRightButton alloc] init];
    [thumbBtn setTitle:@"" forState:UIControlStateNormal];
    [thumbBtn setTitleColor:MHGlobalShadowBlackTextColor forState:UIControlStateNormal];
    [thumbBtn setImage:[UIImage imageNamed:@"mh_thumb"] forState:UIControlStateNormal];
    [thumbBtn setImage:[UIImage imageNamed:@"mh_thumb_sel"] forState:UIControlStateSelected];
    thumbBtn.titleLabel.font = MHMediumFont(MHPxConvertPt(12.0f));
    self.thumbBtn = thumbBtn;
    [scrollView addSubview:thumbBtn];
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 简介
    [self.summary mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(MHGlobalViewLeftInset);
        make.top.equalTo(self).with.offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(MHPxConvertPt(40));
        
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.equalTo(self).with.offset(0);
        make.width.and.height.mas_equalTo(MHPxConvertPt(40));
        
    }];
    
    [self.separate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
        make.top.equalTo(self.summary.mas_bottom);
        
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.separate.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.thumbBtn.mas_bottom).with.offset(MHGlobalViewInterInset).priorityLow();
        
    }];
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.scrollView.mas_left).with.offset(MHGlobalViewTopInset);
        make.right.equalTo(self.scrollView.mas_right).with.offset(-1 * MHGlobalViewTopInset);
        make.top.equalTo(self.scrollView.mas_top).with.offset(MHGlobalViewTopInset);
        make.bottom.equalTo(self.content.mas_top).with.offset(-1 * MHGlobalViewTopInset);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(MHGlobalViewInterInset);
        make.left.equalTo(self.title.mas_left);
        make.right.equalTo(self.title.mas_right);
    }];
    
    
    [self.thumbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.content.mas_bottom).with.offset(2 * MHGlobalViewInterInset);
        make.left.equalTo(self.title.mas_left).with.offset(0);
        make.height.mas_equalTo(25);
        make.width.mas_lessThanOrEqualTo(MHMainScreenWidth-2 * MHGlobalViewLeftInset);
    }];
}


- (void)setMedia:(MHYouKuMedia *)media
{
    _media = media;
    
    self.title.text = [NSString stringWithFormat:@"名称：%@",media.mediaTitle];
    
    self.content.text = [NSString stringWithFormat:@"%@",media.mediaContent];
    
    [self.thumbBtn setTitle:[NSString stringWithFormat:@"%@人赞过",media.thumbNumsString] forState:UIControlStateNormal];
    self.thumbBtn.selected = media.isThumb;
    
}


#pragma mark - 事件
- (void)_closeBtnClicked:(UIButton *)sender
{
    !self.closeCallBack ? :self.closeCallBack(self);
}

@end
