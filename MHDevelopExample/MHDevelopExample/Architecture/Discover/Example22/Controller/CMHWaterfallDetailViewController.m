//
//  CMHWaterfallDetailViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/6/11.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHWaterfallDetailViewController.h"
#import "CMHWaterfall.h"
@interface CMHWaterfallDetailViewController ()
/// waterfall
@property (nonatomic , readwrite , strong) CMHWaterfall *waterfall;
/// imageView
@property (nonatomic , readwrite , weak) UIImageView *imageView;
@end

@implementation CMHWaterfallDetailViewController

- (instancetype)initWithParams:(NSDictionary *)params{
    if (self = [super initWithParams:params]) {
        self.waterfall = params[CMHViewControllerUtilKey];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置
    [self _setup];
    
    /// 设置导航栏
    [self _setupNavigationItem];
    
    /// 设置子控件
    [self _setupSubViews];
    
    /// 布局子空间
    [self _makeSubViewsConstraints];
}

#pragma mark - 事件处理Or辅助方法

#pragma mark - 初始化
- (void)_setup{
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem{
    self.title = self.waterfall.title;
}

#pragma mark - 设置子控件
- (void)_setupSubViews{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:self.waterfall.imageUrl] placeholder:MHImageNamed(@"placeholder_image") options:CMHWebImageOptionAutomatic completion:NULL];
}

#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints{
    
    CGFloat width = MH_SCREEN_WIDTH - 2 * 15;
    CGFloat height = self.waterfall.height * width / self.waterfall.width;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
}

#pragma mark - Setter & Getter
@end
