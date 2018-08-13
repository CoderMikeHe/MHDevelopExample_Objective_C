//
//  CMHFileView.m
//  MHDevelopExample
//
//  Created by lx on 2018/7/23.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHFileView.h"
#import "CMHFile.h"
@interface CMHFileView ()

/// imageView
@property (nonatomic , readwrite , weak) UIImageView *imageView;

/// 删除按钮
@property (nonatomic , readwrite , weak) UIButton *deleteBtn;

/// 视频预览
@property (nonatomic , readwrite , weak) UIImageView *videoPreview;

/// file
@property (nonatomic , readwrite , strong) CMHFile *file;

/// coverView
@property (nonatomic , readwrite , weak) UIView *coverView;


@end


@implementation CMHFileView

- (void)configureModel:(CMHFile *)file{
    self.file = file;
    
    self.imageView.image = file.thumbImage;

    if (file.fileType == CMHFileTypeNone) {
        self.deleteBtn.hidden = YES;
        self.videoPreview.hidden = YES;
    }else if (file.fileType == CMHFileTypePicture){
        self.deleteBtn.hidden = NO;
        self.videoPreview.hidden = YES;
    }else{
        self.deleteBtn.hidden = NO;
        self.videoPreview.hidden = NO;
    }
    
    /// 是否显示遮罩
    self.coverView.hidden = !file.disablePreview;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
- (void)_deleteBtnDidClicked:(UIButton *)sender{
    NSLog(@"+++++ 点击删除按钮 +++++");
    !self.deleteCallback ? : self.deleteCallback(self);
}


#pragma mark - Private Method
- (void)_setup{
}

#pragma mark - 创建自控制器
- (void)_setupSubViews{
    /// 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    self.imageView = imageView ;
    [self addSubview:imageView];
    

    /// 删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:MHImageNamed(@"close") forState:UIControlStateNormal];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(_deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    /// 视频预览
    UIImageView *videoPreview = [[UIImageView alloc] initWithImage:MHImageNamed(@"album_preview_play")];
    self.videoPreview = videoPreview;
    [self addSubview:videoPreview];
    
    /// 遮盖
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
    self.coverView = coverView ;
    coverView.hidden = YES;
    [self addSubview:coverView];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.centerX.equalTo(self.imageView.mas_right);
        make.centerY.equalTo(self.imageView.mas_top);
    }];
    
    [self.videoPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.center.equalTo(self);
    }];
    
    
}

/// CoderMikeHe Fixed Bug : 解决按钮超出View点击无响应的Bug
/// https://www.jianshu.com/p/2e074db792ba
/// https://www.jianshu.com/p/933dd3ed2504
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    /// 一定要做这个判断，以免用户点击空白之处 恰巧满足下面的情况而闪退
    if (self.isHidden) {
        return nil;
    }
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        /// 一定要做这个判断，以免用户点击空白之处 恰巧满足下面的情况而闪退
        if (self.deleteBtn.isHidden) {
            return nil;
        }
        // 转换坐标系
        CGPoint newPoint = [self.deleteBtn convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.deleteBtn.bounds, newPoint)) {
            view = self.deleteBtn;
        }
    }
    return view;
}



@end
