//
//  XMGLabel.m
//  03-MenuController
//
//  Created by xiaomage on 15/8/3.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGLabel.h"

@implementation XMGLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)]];
}

/**
 * 让label有资格成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

///**
// * label能执行哪些操作(比如copy, paste等等)
// * @return  YES:支持这种操作
// */
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:)) return YES;
//    
//    return NO;
//}
//
//- (void)cut:(UIMenuController *)menu
//{
//    // 将自己的文字复制到粘贴板
//    [self copy:menu];
//    
//    // 清空文字
//    self.text = nil;
//}
//
//- (void)copy:(UIMenuController *)menu
//{
//    // 将自己的文字复制到粘贴板
//    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    board.string = self.text;
//}
//
//- (void)paste:(UIMenuController *)menu
//{
//    // 将粘贴板的文字 复制 到自己身上
//    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    self.text = board.string;
//}

- (void)labelClick
{
    // 1.label要成为第一响应者(作用是:告诉UIMenuController支持哪些操作, 这些操作如何处理)
    [self becomeFirstResponder];
    
    
    
    // 2.显示MenuController
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuItems = @[
                       [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(warn:)]
                       ];
    // targetRect: MenuController需要指向的矩形框
    // targetView: targetRect会以targetView的左上角为坐标原点
    [menu setTargetRect:self.bounds inView:self];
//    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}


/**
 * 通过第一响应者的这个方法告诉UIMenuController可以显示什么内容
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ( (action == @selector(copy:) && self.text) // 需要有文字才能支持复制
        || (action == @selector(cut:) && self.text) // 需要有文字才能支持剪切
        || action == @selector(paste:)
        || action == @selector(ding:)
        || action == @selector(reply:)
        || action == @selector(warn:)) return YES;
    
    return NO;
}

#pragma mark - 监听MenuItem的点击事件
- (void)cut:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
    [UIPasteboard generalPasteboard].string = self.text;
    // 清空文字
    self.text = nil;
}

- (void)copy:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)paste:(UIMenuController *)menu
{
    // 将粘贴板的文字赋值给label
    self.text = [UIPasteboard generalPasteboard].string;
}

- (void)ding:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}

- (void)reply:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}

- (void)warn:(UIMenuController *)menu
{
    NSLog(@"%s %@", __func__, menu);
}

@end
