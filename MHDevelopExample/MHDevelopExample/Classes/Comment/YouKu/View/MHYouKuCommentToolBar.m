//
//  MHYouKuCommentToolBar.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuCommentToolBar.h"

@interface MHYouKuCommentToolBar ()

/** 发送 */
@property (nonatomic , weak) UIButton *sendBtn;

/** 字数 */
@property (nonatomic , weak) UILabel *words ;

/** 分割线 */
@property (nonatomic , weak) MHDivider *divider;

@end




@implementation MHYouKuCommentToolBar

+ (instancetype)commentToolBar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
    }
    return self;
}
#pragma mark - 公共方法

- (void) textDidChanged:(YYTextView *)textView
{
    //计算
    self.sendBtn.enabled = textView.attributedText.length;
    
    NSInteger words = MHCommentMaxWords-textView.attributedText.length;
    
    // 设置颜色和文字
    self.words.textColor = (words<0)?[UIColor redColor]:MHGlobalGrayTextColor;
    self.words.text = [NSString stringWithFormat:@"%zd",words];
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 发送按钮
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:MHGlobalWhiteTextColor forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage mh_resizedImage:@"comment_send_nor"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage mh_resizedImage:@"comment_send_disable"] forState:UIControlStateDisabled];
    [sendBtn addTarget:self action:@selector(_sendBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
    sendBtn.enabled = NO;
    [self addSubview:sendBtn];
    self.sendBtn = sendBtn;
    
    
    // 字数余额
    UILabel *words = [[UILabel alloc] init];
    words.font = MHFont(MHPxConvertPt(12.0f), NO);
    words.textAlignment = NSTextAlignmentRight;
    words.textColor = MHGlobalShadowBlackTextColor;
    words.text = @"300";
    [self addSubview:words];
    self.words = words;
    
    
    // 分割线
    MHDivider *divider = [[MHDivider alloc] init];
    self.divider = divider;
    [self addSubview:divider];
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局发送
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10.0f);
        make.top.equalTo(self).with.offset(6);
        make.bottom.equalTo(self).with.offset(-6);
        make.width.mas_equalTo(60);
    }];
    
    // 布局字数
    [self.words mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendBtn.mas_left).with.offset(-10.0f);
        make.top.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.width.mas_equalTo(70);
    }];
    
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(MHGlobalBottomLineHeight);
    }];
    
}



#pragma mark - 事件处理
- (void)_sendBtnDidClicked:(UIButton *)sender
{
    // 发送
    [self _send];
}


#pragma mark - 辅助方法

- (void)_send
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentToolBarForSendAction:)]) {
        [self.delegate commentToolBarForSendAction:self];
    }
}

@end
