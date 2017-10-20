//
//  MHYouKuCommentController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHYouKuCommentController.h"
#import "MHYouKuCommentToolBar.h"
#import "MHTopicManager.h"

@interface MHYouKuCommentController ()<YYTextViewDelegate,MHYouKuCommentToolBarDelegate>

/** 输入框 */
@property (nonatomic , weak) YYTextView *textView;
/** 工具条 */
@property (nonatomic , strong) MHYouKuCommentToolBar *toolBar;
/** cacheText */
@property (nonatomic , copy) NSString *cacheText;

@end

@implementation MHYouKuCommentController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.textView becomeFirstResponder];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
    // 监听通知中心
    [self _addNotificationCenter];
    
    //
}

#pragma mark - 事件处理

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        
        self.textView.frame = self.view.bounds;
        
    }];
}
/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 取出键盘高度
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    
    CGRect frame = self.textView.frame;
    frame.size.height = self.view.mh_height - keyboardH;
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = frame;
    }];
}


- (void)_close
{
    if ([self.cacheText isEqualToString:self.textView.text]) {
        // 如果缓存值跟现在的值一样 则跳过
    }else{
        // 如果不一样则需要保存
        if (self.textView.text.length==0)
        {
            // 输入框没做任何处理
            if (MHStringIsNotEmpty(self.cacheText)) {
                // 存@""值
                [[MHTopicManager sharedManager].commentDictionary setValue:@"" forKey:self.mediabase_id];
            }
        }else{
            //
            [[MHTopicManager sharedManager].commentDictionary setValue:self.textView.text forKey:self.mediabase_id];
        }
    }
    // 退出
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark - 初始化
- (void)_setup
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 从内存存储取值
    self.cacheText = [[MHTopicManager sharedManager].commentDictionary objectForKey:self.mediabase_id];
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"评论";
    
    UIImage *rightImage = [UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"comment_close"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(_close)];
    
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // textView
    YYTextView *textView = [[YYTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = MHFont(MHPxConvertPt(15.0f), NO);
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = MHGlobalBlackTextColor;
    textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
    textView.showsVerticalScrollIndicator = NO;
    textView.alwaysBounceVertical = YES;
    textView.allowsCopyAttributedString = NO;
    textView.placeholderText = @"此时此刻的感想......";
    textView.placeholderFont = textView.font;
    textView.placeholderTextColor = MHGlobalGrayTextColor;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.delegate = self;
    
    
    // 设置弹出框
    textView.inputAccessoryView = self.toolBar;
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 设置缓存值
    textView.text = self.cacheText;
    
    
    /// 适配 iOS11
    MHAdjustsScrollViewInsets_Never(self.textView);
}




#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Getter
- (MHYouKuCommentToolBar *)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[MHYouKuCommentToolBar alloc] init];
        _toolBar.mh_height = MHCommentToolBarHeight;
        _toolBar.delegate = self;
    }
    return _toolBar;
}



#pragma mark - YYTextViewDelegate
- (void) textViewDidChange:(YYTextView *)textView
{
    // 文字改变
    [self.toolBar textDidChanged:textView];
}

- (BOOL) textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        // 发送评论
        [self _send];
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    
    return YES;
}


#pragma mark - JLVideoCommentToolBarDelegate
- (void) commentToolBarForSendAction:(MHYouKuCommentToolBar *)commentToolBar
{
    // 发送
    [self _send];

}


#pragma mark - 辅助方法

- (void)_send
{
    if (self.textView.attributedText.length == 0) {
        [self mh_showTopHint:@"评论内容不能为空"];
        return;
    }
    
    if (self.textView.attributedText.length>300) {
        [self mh_showTopHint:@"评论内容字数超过上限"];
        return;
    }
 
    // 先关闭控制器
    [self _close];
    
    // 假数据
    MHTopic *topic = [[MHTopic alloc] init];
    topic.mediabase_id = self.mediabase_id;
    topic.topicId = [NSString stringWithFormat:@"%zd",[NSObject mh_randomNumber:30 to:100]];
    topic.thumbNums = 0;
    topic.thumb = NO;
    topic.creatTime = [NSDate mh_currentTimestamp];
    topic.text = self.textView.attributedText.string;
    topic.commentsCount = 0;
    MHUser *user = [[MHUser alloc] init];
    user.avatarUrl = [AppDelegate sharedDelegate].account.avatarUrl;
    user.nickname = [AppDelegate sharedDelegate].account.nickname;
    user.userId = [AppDelegate sharedDelegate].account.userId;
    topic.user = user;
    
    // 模拟网络发送
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *mediaBaseId = self.mediabase_id;
        // 解析数据
        if (MHStringIsNotEmpty(mediaBaseId)) {
            // 移除掉内存缓存的字段
            [[MHTopicManager sharedManager].commentDictionary removeObjectForKey:self.mediabase_id];
        }
        
        // PS: 通知回调 由于有两个控制器需要回调数据 所以利用通知回调 保证地址一致
        [MHNotificationCenter postNotificationName:MHCommentSuccessNotification object:nil userInfo:@{MHCommentSuccessKey:[self _topicFramesWithTopics:@[topic]].lastObject}];
        
    });
    
    
    
            
}


/**topic --- topicFrame */
- (NSArray *)_topicFramesWithTopics:(NSArray *)topics
{
    NSMutableArray *frames = [NSMutableArray array];
    
    for (MHTopic *topic in topics) {
        
        // 这里不要判断评论个数大于2 显示全部评论数
        if (topic.commentsCount>2) {
            // 设置假数据
            MHComment *comment = [[MHComment alloc] init];
            comment.commentId = MHAllCommentsId;
            comment.text = [NSString stringWithFormat:@"查看全部%zd条回复" , topic.commentsCount];
            // 添加假数据
            [topic.comments addObject:comment];
        }
        
        //
        MHTopicFrame *frame = [[MHTopicFrame alloc] init];
        // 传递微博模型数据，计算所有子控件的frame
        frame.topic = topic;
        [frames addObject:frame];
    }
    return frames;
}

@end
