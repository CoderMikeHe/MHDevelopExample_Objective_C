//
//  MHBuDeJieController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHBuDeJieController.h"
#import "MHTopicController.h"


@interface MHBuDeJieController ()<UIScrollViewDelegate>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation MHBuDeJieController

- (void)dealloc
{
    MHDealloc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 初始化子控制器
    [self _setupChildController];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 设置子控件
    [self _setupSubViews];
    
    // 监听通知中心
    [self _addNotificationCenter];
}
#pragma mark - 公共方法


#pragma mark - 私有方法

#pragma mark - 初始化
- (void)_setup
{
    self.view.backgroundColor = MHColor(223, 223, 223);
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 取消侧滑
    self.fd_interactivePopDisabled = YES;
}

#pragma mark - 初始化子控制器
- (void)_setupChildController
{
    MHTopicController *all = [[MHTopicController alloc] init];
    all.title = @"全部";
    [self addChildViewController:all];
    
    MHTopicController *video = [[MHTopicController alloc] init];
    video.title = @"视频";
    [self addChildViewController:video];
    
    MHTopicController *voice = [[MHTopicController alloc] init];
    voice.title = @"声音";
    [self addChildViewController:voice];
    
    MHTopicController *picture = [[MHTopicController alloc] init];
    picture.title = @"图片";
    [self addChildViewController:picture];
    
    MHTopicController *word = [[MHTopicController alloc] init];
    word.title = @"段子";
    [self addChildViewController:word];
}
#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 设置子控件
- (void)_setupSubViews
{
    // 设置顶部的标签栏
    [self _setupTitlesView];
    
    // 底部的scrollView
    [self _setupContentView];
}

/**
 * 设置顶部的标签栏
 */
- (void)_setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.mh_width = self.view.mh_width;
    titlesView.mh_height = MHTitilesViewH;
    titlesView.mh_y =MHTitilesViewY;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.mh_height = 2;
    indicatorView.tag = -1;
    indicatorView.mh_y = titlesView.mh_height - indicatorView.mh_height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.mh_width / self.childViewControllers.count;
    CGFloat height = titlesView.mh_height;
    NSInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.mh_height = height;
        button.mh_width = width;
        button.mh_x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        // 强制布局(强制更新子控件的frame)
        //[button layoutIfNeeded];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(_titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            self.selectedButton = button;
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.mh_width = button.titleLabel.mh_width;
            self.indicatorView.mh_centerX = button.mh_centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}



/**
 * 底部的scrollView
 */
- (void)_setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    
    contentView.contentSize = CGSizeMake(contentView.mh_width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}



#pragma mark - 点击事件
- (void)_titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.mh_width = button.titleLabel.mh_width;
        self.indicatorView.mh_centerX = button.mh_centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.mh_width;
    [self.contentView setContentOffset:offset animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.mh_width;
    
    // 取出子控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回，这里是小细节，其实同一个view被添加N次 == 添加一次
    if ([willShowVc isViewLoaded]) return;
    
    willShowVc.view.mh_x = scrollView.contentOffset.x;
    willShowVc.view.mh_y = 0; // 设置控制器view的y值为0(默认是20)
    willShowVc.view.mh_height = scrollView.mh_height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:willShowVc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.mh_width;
    [self _titleClick:self.titlesView.subviews[index]];
}

@end
