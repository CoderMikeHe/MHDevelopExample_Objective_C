//
//  MHYouKuBottomToolBar.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  底部工具条

#import "MHYouKuBottomToolBar.h"
#import "MHYouKuVerticalSeparateButton.h"
#import "MHYouKuMedia.h"

@interface MHYouKuBottomToolBar ()



/** 点赞 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * thumbBtn;

/** 评论 **/
@property (nonatomic , weak) MHYouKuVerticalSeparateButton *commentBtn;

/** 收藏 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * collectBtn;

/** 下载 **/
@property (nonatomic , weak) MHYouKuVerticalSeparateButton *downloadBtn;

/** 分享 */
@property (nonatomic , weak) MHYouKuVerticalSeparateButton * shareBtn;

/** 分割线 **/
@property (nonatomic , weak) MHImageView *separate ;


/** 按钮数组 **/
@property (nonatomic,strong) NSMutableArray  *buttons;

@end


@implementation MHYouKuBottomToolBar
#pragma mark - 公共方法
- (void)setMedia:(MHYouKuMedia *)media
{
    _media = media;
    
    self.thumbBtn.selected = media.isThumb;
    [self.thumbBtn setTitle:media.thumbNumsString forState:UIControlStateNormal];
    
    
    [self.commentBtn setTitle:media.commentNumsString forState:UIControlStateNormal];
    
}



#pragma mark - 私有方法

#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 初始化子控件
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];

    }
    return self;
}

#pragma mark - 初始化
- (void)_setup
{
    
}

- (void)_setupSubViews
{
    // 分享按钮
    self.thumbBtn = [self _setupButtonWithTitle:@"0" imageName:@"mh_thumb" selectedImageName:@"mh_thumb_sel" type:MHYouKuBottomToolBarTypeThumb];
    [self.thumbBtn showRightSeparate];
    
    // 评论
    self.commentBtn = [self _setupButtonWithTitle:@"0" imageName:@"mh_comment" selectedImageName:nil type:MHYouKuBottomToolBarTypeComment];
    [self.commentBtn showRightSeparate];
    
    // 收藏
    self.collectBtn = [self _setupButtonWithTitle:nil imageName:@"player_collection" selectedImageName:nil type:MHYouKuBottomToolBarTypeCollect];
    [self.collectBtn showRightSeparate];
    
    // 下载
    self.downloadBtn = [self _setupButtonWithTitle:nil imageName:@"mh_download" selectedImageName:nil type:MHYouKuBottomToolBarTypeDownload];
    [self.downloadBtn showRightSeparate];
    
    // 分享
    self.shareBtn = [self _setupButtonWithTitle:nil imageName:@"mh_share" selectedImageName:nil type:MHYouKuBottomToolBarTypeShare];
    
    // 分割线
    MHImageView *separate = [MHImageView imageView];
    separate.backgroundColor = MHGlobalBottomLineColor;
    [self addSubview:separate];
    self.separate = separate;
}



#pragma mark - 布局子控件
- (void) _makeSubViewsConstraints
{
    
    UIButton *lastButton = nil;
    NSInteger buttonsCount = self.buttons.count;
    for (NSInteger i = 0; i < buttonsCount; i++) {
        
        UIButton *button = self.buttons[i];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
        }];
        
        if (lastButton) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButton.mas_right);
                make.width.equalTo(lastButton.mas_width);
            }];
            
        }else{
            
            // 第一个按钮
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                
            }];
            
        }
        
        lastButton = button;
        
    }
    // 最后一个按钮
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        
    }];
    
    // 分割线
    [self.separate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        
    }];
    
    
}


#pragma mark - 辅助方法
// 添加一个按钮
- (MHYouKuVerticalSeparateButton *)_setupButtonWithTitle:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName type:(MHYouKuBottomToolBarType)type
{
    MHYouKuVerticalSeparateButton *button = [[MHYouKuVerticalSeparateButton alloc] init];
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    if (MHStringIsNotEmpty(title)) {
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:MHGlobalBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = MHMediumFont(MHPxConvertPt(12.0f));
    }
    
    if (MHStringIsNotEmpty(imageName))
    {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }

    if (MHStringIsNotEmpty(selectedImageName))
    {
        [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    // 添加事件
    [button addTarget:self action:@selector(_buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // tag
    [button setTag:type];
    
    // 加到view
    [self addSubview:button];
    
    // 添加到数组里面去
    [self.buttons addObject:button];

    return button;
}


#pragma mark - 按钮点击事件
- (void)_buttonDidClicked:(UIButton *)sender
{
    // 代理回调
    if(self.delegate && [self.delegate respondsToSelector:@selector(bottomToolBar:didClickedButtonWithType:)]){
        [self.delegate bottomToolBar:self didClickedButtonWithType:sender.tag];
    }
    
}

@end
