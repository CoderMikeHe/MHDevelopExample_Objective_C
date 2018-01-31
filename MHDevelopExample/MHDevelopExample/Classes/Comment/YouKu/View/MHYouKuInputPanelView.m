//
//  MHYouKuInputPanelView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuInputPanelView.h"
#import "MHTopicManager.h"


@interface MHYouKuInputPanelView ()<YYTextViewDelegate>

/** 底部工具条 */
@property (nonatomic , weak) UIView *bottomToolBar;

/** 头像 */
@property (nonatomic , weak) MHImageView *avatarView;

/** commentLabel */
@property (nonatomic , weak) YYLabel *commentLabel;

/** topView */
@property (nonatomic , weak) UIView *topView;

/** textView */
@property (nonatomic , weak) YYTextView *textView;

/** bottomView */
@property (nonatomic , weak) UIView *bottomView;

/** 当前字数 */
@property (nonatomic , weak) YYLabel *words;

/** 表情  */
@property (nonatomic , weak) UIButton *emotionButton;

/** 记录之前编辑框的高度 */
@property (nonatomic , assign) CGFloat previousTextViewContentHeight;

/** 记录键盘的高度 */
@property (nonatomic , assign) CGFloat keyboardHeight;

/** cacheText */
@property (nonatomic , copy) NSString *cacheText;





@end

@implementation MHYouKuInputPanelView

- (void)dealloc
{
    [self _unregisterKeyboardNotification];
    
    MHDealloc;
}

+ (instancetype)inputPanelView
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
        
        // 添加通知中心
        [self _addNotificationCenter];
        
    }
    return self;
}
#pragma mark - 公共方法
- (void) show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self setNeedsUpdateConstraints];
    [self updateFocusIfNeeded];
    [self layoutIfNeeded];
    
    // 延迟一会儿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)dismissByUser:(BOOL)state
{
    if (!state) {
        // 自动消失
        if ([self.cacheText isEqualToString:self.textView.text]) {
            // 未做处理
        }else{
            // 如果不一样则需要保存
            if (self.textView.text.length==0)
            {
                //输入框没做任何处理
                if (MHStringIsNotEmpty(self.cacheText)) {
                    // 存@""值
                    [[MHTopicManager sharedManager].replyDictionary setValue:@"" forKey:self.commentReply.commentReplyId];
                }
            }else{
                [[MHTopicManager sharedManager].replyDictionary setValue:self.textView.text forKey:self.commentReply.commentReplyId];
            }
        }
    }else{
        // 解析数据
        [[MHTopicManager sharedManager].replyDictionary removeObjectForKey:self.commentReply.commentReplyId];
    }
    
    [self _dismiss];
}

- (void)setCommentReply:(MHCommentReply *)commentReply
{
    _commentReply = commentReply;
    // 设置数据
    [MHWebImageTool setImageWithURL:commentReply.user.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:self.avatarView];
    self.commentLabel.text = commentReply.text;
    // 设置placeholder
    self.textView.placeholderText = [NSString stringWithFormat:@"回复%@",commentReply.user.nickname];
    // 设置text
    // 获取缓存text
    self.cacheText = [[MHTopicManager sharedManager].replyDictionary objectForKey:commentReply.commentReplyId];
    // 缓存字体
    self.textView.text = self.cacheText;
}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup{
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 设置控制层
    [self _setupControlView];
    
    // 设置底部工具条
    [self _setupBottomToolBar];
}


// 设置控制层
- (void)_setupControlView
{
    UIControl *backgroundControl = [[UIControl alloc] init];
    backgroundControl.backgroundColor = MHAlphaColor(.0, .0, .0, .2);
    [backgroundControl addTarget:self action:@selector(_backgroundDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundControl];
    
    [backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

// 设置底部工具条
- (void)_setupBottomToolBar
{
    // 底部工具条
    UIView *bottomToolBar = [[UIView alloc] init];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomToolBar];
    self.bottomToolBar = bottomToolBar;
    
    // 顶部
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    self.topView = topView;
    [bottomToolBar addSubview:topView];
    
    
    
    CGFloat avatarWH = 20.f;
    // 头像
    MHImageView *avatarView = [MHImageView imageView];
    avatarView.image = MHGlobalUserDefaultAvatar;
    avatarView.layer.cornerRadius = avatarWH *.5f;
    avatarView.layer.masksToBounds = YES;
    self.avatarView = avatarView;
    [topView addSubview:avatarView];
    
    // 评论
    YYLabel *commentLabel = [[YYLabel alloc] init];
    commentLabel.textColor = MHGlobalGrayTextColor;
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = MHFont(MHPxConvertPt(11.0f), NO);
    commentLabel.textColor = MHGlobalGrayTextColor;
    self.commentLabel = commentLabel;
    [topView addSubview:commentLabel];
    
    // textView
    YYTextView *textView = [[YYTextView alloc] init];
    textView.font = MHFont(MHPxConvertPt(13.0f), NO);
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = MHGlobalBlackTextColor;
    UIEdgeInsets insets = textView.textContainerInset;
    insets.left = 10;
    insets.right = 10;
    textView.textContainerInset = insets;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.layer.cornerRadius = MHPxConvertPt(5.0f);
    textView.layer.borderWidth = MHPxConvertPt(1.0f);
    textView.layer.borderColor = MHColorFromHexString(@"#FB9A4B").CGColor;
    textView.backgroundColor = MHColorFromHexString(@"#F5F5F5");
    textView.placeholderFont = textView.font;
    textView.placeholderTextColor = MHGlobalGrayTextColor;
    textView.delegate = self;
    self.textView = textView;
    [bottomToolBar addSubview:textView];
    
    // bottom
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [bottomToolBar addSubview:bottomView];
    
    // words
    YYLabel *words = [[YYLabel alloc] init];
    words.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"0/300字"];
    attributedText.yy_font = MHFont(MHPxConvertPt(9.0f), NO);
    attributedText.yy_color = MHGlobalGrayTextColor;
    words.attributedText = attributedText;
    [bottomView addSubview: words];
    self.words = words;
    
    // 表情按钮
    UIButton *emotionButton = [[UIButton alloc] init];
    self.emotionButton = emotionButton;
    [bottomView addSubview:emotionButton];
    
}
#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局bottomToolBar
    [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(MHTopicCommentToolBarMinHeight);
        make.height.mas_equalTo(MHTopicCommentToolBarMinHeight);
        
    }];
    
    
    // 布局topView
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.bottomToolBar);
        make.height.mas_equalTo(35);
    }];
    
    
    // 布局头像
    CGFloat avatarWH = MHPxConvertPt(20.0f);
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.mas_equalTo(avatarWH);
        make.left.equalTo(self.topView).with.offset(MHPxConvertPt(10.0f));
        make.centerY.equalTo(self.topView);
        
    }];
    
    // 布局评论
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarView.mas_right).with.offset(MHPxConvertPt(5.0f));
        make.right.equalTo(self.topView).with.offset(MHPxConvertPt(-19.0f));
        make.top.and.bottom.equalTo(self.topView);
        
    }];
    
    
    // 布局textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomToolBar.mas_left).with.offset(MHPxConvertPt(10.0f));
        make.right.equalTo(self.bottomToolBar.mas_right).with.offset(MHPxConvertPt(-10.0f));
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    
    
    // 布局底部
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.bottomToolBar);
        make.height.mas_equalTo(40);
    }];
    
    // 布局字数
    [self.words mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(MHPxConvertPt(19.0f));
        make.top.and.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.emotionButton.mas_left);
    }];
    
    
    // 布局按钮
    [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.and.bottom.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView.mas_height);
        
    }];
}


#pragma mark - 事件处理
/** 监听键盘的弹出和隐藏
 */
- (void)_keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 最终尺寸
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 开始尺寸
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 动画时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = ([userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 ) | UIViewAnimationOptionBeginFromCurrentState;
    
    __weak typeof(self) weakSelf = self;
    
    void(^animations)(void) = ^{
        // 回调
        [weakSelf _willShowKeyboardWithFromFrame:beginFrame toFrame:endFrame];
    };
    
    // 执行动画
    [UIView animateWithDuration:duration delay:0.0f options:options animations:animations completion:^(BOOL finished) {
        
        
        
    }];
    
}

/**
 背景被点击
 */
- (void)_backgroundDidClicked:(UIControl *)sender
{
    [self dismissByUser:NO];
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 添加键盘监听
    [self _registerKeyboardNotification];
}

// 添加监听
- (void)_registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 取消监听
- (void)_unregisterKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 代理
- (void)textViewDidChange:(YYTextView *)textView
{
    // 改变高度
    [self _bottomToolBarWillChangeHeight:[self _getTextViewHeight:textView]];
    
    // 设置提醒文字
    [self _textViewWordsDidChange:textView];
    
}


- (BOOL) textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        // 发送回复
        [self _send];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    
    return YES;
}

#pragma mark - 辅助方法
/** 键盘改变  后期于鏊考虑表情键盘 */
- (void)_willShowKeyboardWithFromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame
{

    if (fromFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        // 键盘弹起
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:toFrame.size.height];
        
    }else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        // 键盘落下
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:0];
        
    }else
    {
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:toFrame.size.height];
    }
}

/** 距离控制器底部的高度 */
- (void)_bottomToolBarWillChangeBottomHeight:(CGFloat)bottomHeight
{
    // 记录键盘的高度
    self.keyboardHeight = bottomHeight;
    
    // fix 掉键盘落下 输入框还没落下的bug 键盘掉下的bug
    if (bottomHeight<=0) {
        bottomHeight = -1 * MHMainScreenHeight;
    }
    // 之前bottomToolBar的尺寸
    [self.bottomToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        // 设置高度
        make.bottom.equalTo(self).with.offset(-1 * bottomHeight);
    }];
    
    
    // 键盘高度改变了也要去查看一下bottomToolBar的布局
    [self _bottomToolBarWillChangeHeight:[self _getTextViewHeight:self.textView]];
    
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    // 适当时候更新布局
    [self layoutIfNeeded];
    
}

/** 获取编辑框的高度 */
- (CGFloat)_getTextViewHeight:(YYTextView *)textView{
    return textView.textLayout.textBoundingSize.height;
}

#pragma mark - 编辑框将要到那个高度
- (void)_bottomToolBarWillChangeHeight:(CGFloat)toHeight{
    // 需要加上 MHTopicCommentToolBarWithNoTextViewHeight才是bottomToolBarHeight
    toHeight = toHeight + MHTopicCommentToolBarWithNoTextViewHeight;
    
    if (toHeight < MHTopicCommentToolBarMinHeight || self.textView.attributedText.length == 0){
        toHeight = MHTopicCommentToolBarMinHeight;
    }
    
    // 不允许遮盖住 视频播放
    CGFloat maxHeight = MHMainScreenHeight - MHTopicCommentToolBarMinTopInset - self.keyboardHeight;
    
    if (toHeight > maxHeight) { toHeight = maxHeight ;}
    
    // 高度是之前的高度  跳过
    if (toHeight == self.previousTextViewContentHeight) return;
    
    // 布局
    [self.bottomToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        //
        make.height.mas_equalTo(toHeight);
        //
    }];
    
    self.previousTextViewContentHeight = toHeight;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.25f animations:^{
        // 适当时候更新布局
        [self layoutIfNeeded];
    }];
    
}

/** textView文字发生改变 */
- (void)_textViewWordsDidChange:(YYTextView *)textView
{
    NSString *text = [NSString stringWithFormat:@"%zd/%zd",textView.attributedText.length , MHCommentMaxWords];
    UIFont *font = MHFont(MHPxConvertPt(9.0f), NO);
    UIColor *color = textView.attributedText.length<=300 ? MHGlobalGrayTextColor : [UIColor redColor];
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%zd/",textView.attributedText.length]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    attributedText.yy_font = font;
    attributedText.yy_color = MHGlobalGrayTextColor;
    [attributedText yy_setColor:color range:range];
    self.words.attributedText = attributedText;
}

/** 发送 */
- (void) _send
{
    if (self.textView.attributedText.length==0) {
        [MBProgressHUD mh_showTips:@"回复内容不能为空"];
        return;
    }
    
    if (self.textView.attributedText.length >MHCommentMaxWords) {
        [MBProgressHUD mh_showTips:@"回复内容超过上限"];
        return;
    }
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputPanelView:attributedText:)]) {
        // 把内容调回去
        [self.delegate inputPanelView:self attributedText:self.textView.text];
    }

    // 隐藏
    [self dismissByUser:YES];
}

/** 隐藏 */
- (void)_dismiss
{
    [self.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 从父控件移除
        [self removeFromSuperview];
        
    });
    
}


@end
