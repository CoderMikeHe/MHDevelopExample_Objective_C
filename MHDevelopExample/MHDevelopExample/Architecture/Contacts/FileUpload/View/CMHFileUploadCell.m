//
//  CMHFileUploadCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/17.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileUploadCell.h"
#import "CMHSource.h"
#import <DACircularProgress/DACircularProgressView.h>
#import "MHButton.h"
@interface CMHFileUploadCell ()

/// coverView
@property (weak, nonatomic) IBOutlet UIImageView *coverView;

/// deleteBtn
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

/// titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// createAtLabel
@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;

/// source
@property (nonatomic , readwrite , strong) CMHSource *source;

/// progressView
@property (nonatomic , readwrite , weak) DACircularProgressView *progressView;

/// 按钮
@property (nonatomic , readwrite , weak) MHButton *uploadBtn;

/// 进度条
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end


@implementation CMHFileUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /// CoderMikeHe Fixed Bug ： 必须需要指定大小
    DACircularProgressView *progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(10, 10, 76, 76)];
    progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];;
    progressView.roundedCorners = NO;
    progressView.thicknessRatio = .25f;
    progressView.trackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.3];;
    progressView.progress = .5f;
    self.progressView = progressView;
    [self.coverView addSubview:progressView];
    
    /// 上传按钮
    MHButton *uploadBtn = [MHButton buttonWithType:UIButtonTypeCustom];
    [uploadBtn setFrame:CGRectMake(0, 0,self.frame.size.width/2,self.frame.size.width/2)];
    [uploadBtn setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [uploadBtn.layer setMasksToBounds:YES];
    [uploadBtn.layer setCornerRadius:self.frame.size.width/4];
    [uploadBtn setBackgroundColor:[UIColor clearColor]];
    [uploadBtn setImage:[UIImage imageNamed:@"draft_upload"] forState:UIControlStateNormal];
    [uploadBtn setImage:[UIImage imageNamed:@"draft_stop"] forState:UIControlStateSelected];
    [self.coverView addSubview:uploadBtn];
    self.uploadBtn = uploadBtn;
    uploadBtn.frame = progressView.frame;
    
    /// 添加事件
    @weakify(self);
    [[uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable sender) {
        @strongify(self);

        if (self.source.disable) {
            [MBProgressHUD mh_showTips:@"正在提交中，请稍后处理"];
            return;
        }
        
        sender.selected = !sender.isSelected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileUploadCell:needUpload:)]) {
            [self.delegate fileUploadCell:self needUpload:sender.isSelected];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CMHFileUploadCell";
    CMHFileUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self mh_viewFromXib];
    }
    return cell;
}

- (void)configureModel:(CMHSource *)source{
    self.source = source ;
    
    [self.coverView yy_setImageWithURL:[NSURL URLWithString:source.coverUrl] placeholder:MHWebPlaceholderImage() options:CMHWebImageOptionAutomatic completion:NULL];
    self.titleLabel.text = source.title;
    self.createAtLabel.text = source.createDate;
    self.selectionStyle = source.isManualSaveDraft ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    /// 更新进度
    [self refreshProgress:source animated:NO];
}

/// 更新进度
- (void)refreshProgress:(CMHSource *)source animated:(BOOL)animated{
    
    /// 手动存草稿
    if (source.isManualSaveDraft) {
        self.progressView.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.progressLabel.hidden = YES;
        return;
    }
    
    /// 断点续传存草稿
    self.progressView.hidden = NO;
    self.uploadBtn.hidden = NO;
    self.progressLabel.hidden = NO;
    
    /// 设置进度
    [self.progressView setProgress:source.progress animated:animated];
    
    NSString *statusStr = nil;
    if (source.uploadStatus == CMHFileUploadStatusWaiting) {
        self.uploadBtn.selected = NO;
        statusStr = @"已暂停";
    }else{
        self.uploadBtn.selected = YES;
        statusStr = @"上传中";
    }
    
    /// 上传进度
    self.progressLabel.text = [NSString stringWithFormat:@"%@ %.2f%%" , statusStr , source.progress*100];
}



#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - 事件处理Or辅助方法
/// 删除按钮的事件
- (IBAction)_deleteBtnDidClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileUploadCellDidClickedDeleteButton:)]) {
        [self.delegate fileUploadCellDidClickedDeleteButton:self];
    }
}
@end
