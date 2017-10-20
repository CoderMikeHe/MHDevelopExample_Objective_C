//
//  MHTopicCommentCell.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/9.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHTopicCommentCell.h"
#import "MHCommentFrame.h"

@interface MHTopicCommentCell ()

/** 文本内容 */
@property (nonatomic , weak) YYLabel *contentLabel;

@end

@implementation MHTopicCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CommentCell";
    MHTopicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        MHLog(@"....cell嵌套tableView.....创建评论cell...");
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
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
- (void)setCommentFrame:(MHCommentFrame *)commentFrame
{
    _commentFrame = commentFrame;
    
    MHComment *comment = commentFrame.comment;
    
    // 赋值
    self.contentLabel.frame = commentFrame.textFrame;
    // 设置值
    self.contentLabel.attributedText = comment.attributedText;
    
}


#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    // 设置颜色
    self.backgroundColor = MHColorFromHexString(@"#EEEEEE");
    self.contentView.backgroundColor = MHColorFromHexString(@"#EEEEEE");
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 文本
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.numberOfLines = 0 ;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    __weak typeof(self) weakSelf = self;
    contentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        
        // 利用KVC获取UserInfo 其实可以在MHComment模型里面利用 通知告知控制器哪个用户被点击了
        YYTextHighlight *highlight = [containerView valueForKeyPath:@"_highlight"];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(topicCommentCell:didClickedUser:)]) {
            [weakSelf.delegate topicCommentCell:weakSelf didClickedUser:highlight.userInfo[MHCommentUserKey]];
        }
        
        
    };
}


#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    
}


@end
