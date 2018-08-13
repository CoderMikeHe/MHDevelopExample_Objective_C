//
//  CMHFileSourceCell.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileSourceCell.h"
#import "CMHSource.h"
#import "CMHFileView.h"

/// 高度
static CGFloat const CMHTitleLableHeight = 44.0f;

/// 左边距
static CGFloat const CMHFileViewLeftMargin = 16;

/// 内间距
static CGFloat const CMHFileViewInnerMargin = 20;

/// 列数
static NSInteger const CMHFileViewColumn = 4;


@interface CMHFileSourceCell ()<UIGestureRecognizerDelegate>
/// titleLabel
@property (nonatomic , readwrite , weak) UILabel *titleLabel;
/// sourcesView
@property (nonatomic , readwrite , weak) CMHView *sourcesView ;
/// source
@property (nonatomic , readwrite , strong) CMHSource *source;
/// 添加按钮
@property (nonatomic , readwrite , strong) CMHFile *addFile;
@end
@implementation CMHFileSourceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CMHFileSourceCell";
    CMHFileSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)configureModel:(CMHSource *)source{
    self.source = source;
    NSInteger count = source.files.count + 1;
    NSInteger sCount = self.sourcesView.subviews.count;
    for (NSInteger i = 0; i < sCount; i++) {
        CMHFileView *fileView = self.sourcesView.subviews[i];
        if (i < count) {
            fileView.hidden = NO;
            if (i < count - 1) {
                /// 资源文件
                [fileView configureModel:source.files[i]];
            }else{
                /// 添加按钮
                [fileView configureModel:self.addFile];
            }
        }else{
            fileView.hidden = YES;
        }
    }
}


/// 获取cell的高度
+ (CGFloat)fetchCellHeightForSources:(NSArray *)sources{
    
    NSInteger count = sources.count + 1;
    CGFloat WH = (MHMainScreenWidth - CMHFileViewLeftMargin * 2 - (CMHFileViewColumn - 1) * CMHFileViewInnerMargin) / CMHFileViewColumn;
    CGFloat height = CMHTitleLableHeight;
    height = height + (count / CMHFileViewColumn) * (CMHFileViewInnerMargin + WH) + WH;
    return height;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
    }
    return self;
}

#pragma mark - 事件处理Or辅助方法
- (void)_tapFileView:(UIGestureRecognizer *)tapGr{
    CMHFileView *fileView = (CMHFileView *)tapGr.view;
    
    if (fileView.file.disablePreview) {
        [MBProgressHUD mh_showTips:@"此图片不支持预览"];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(fileSourceCell:tapIndex:tapType:)]) {
        [self.delegate fileSourceCell:self tapIndex:fileView.tag tapType:(fileView.file.fileType == CMHFileTypeNone)?CMHTapFileViewTypeAdd:CMHTapFileViewTypePreview];
    }
}
#pragma mark - Private Method
- (void)_setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    
    @weakify(self);
    
    /// titleLabel
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = MHColorFromHexString(@"#333333");
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = MHMediumFont(18.0f);
    titleLabel.text = @"上传资源";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /// 资源View
    CMHView *sourcesView = [[CMHView alloc] init];
    [self.contentView addSubview:sourcesView];
    self.sourcesView = sourcesView;
    
    /// 一口气创建 50 + 1（添加按钮）= 51个图片
    for (NSInteger i = 0;  i < CMHFileMaxCount + 1; i++) {
        CMHFileView *fileView = [[CMHFileView alloc] init];
        fileView.userInteractionEnabled = YES;
        fileView.tag = i;
        /// 添加手势
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapFileView:)];
        tapGr.delegate = self;
        [fileView addGestureRecognizer:tapGr];
        [sourcesView addSubview:fileView];
        /// 监听事件
        fileView.deleteCallback = ^(CMHFileView *fv) {
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(fileSourceCell:tapIndex:tapType:)]) {
                [self.delegate fileSourceCell:self tapIndex:fv.tag tapType:CMHTapFileViewTypeDelete];
            }
        };
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:UIControl.class]) {
        return NO;
    }
    //默认都需要响应
    return  YES;
}




#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(16);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-16);
        make.height.mas_equalTo(CMHTitleLableHeight);
    }];
    
    [self.sourcesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat innerMargin = CMHFileViewInnerMargin;
    CGFloat leftMargin = CMHFileViewLeftMargin;
    CGFloat column = CMHFileViewColumn;
    CGFloat WH = (MHMainScreenWidth - leftMargin * 2 - (column - 1) * innerMargin) / column;
    
    NSInteger count = self.sourcesView.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        CMHFileView *fileView = self.sourcesView.subviews[i];
        CGFloat fileViewX = 16 + (WH + innerMargin) * (i % 4);
        CGFloat fileViewY = (WH + innerMargin) * (i / 4);
        fileView.frame = CGRectMake(fileViewX, fileViewY, WH, WH);
    }
}

#pragma mark - Setter & Getter
- (CMHFile *)addFile{
    if (_addFile == nil) {
        _addFile  = [[CMHFile alloc] init];
        _addFile.fileType = CMHFileTypeNone;
        _addFile.thumbImage = MHImageNamed(@"feedback_add");
    }
    return _addFile ;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
