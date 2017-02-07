//
//  MHNetEaseNewsController.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "MHNetEaseNewsController.h"
#import "MHTopicController.h"
#import "MHTopicLabel.h"

@interface MHNetEaseNewsController () <UIScrollViewDelegate>
/** 顶部的所有标签 */
@property (nonatomic, weak) UIScrollView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation MHNetEaseNewsController

- (void)dealloc
{
    MHDealloc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏
    [self _setupNavigationItem];
    
    // 初始化自控制器
    [self _setupChildController];
    
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
    
    
    MHTopicController *military = [[MHTopicController alloc] init];
    military.title = @"军事";
    [self addChildViewController:military];
    
    MHTopicController *science = [[MHTopicController alloc] init];
    science.title = @"科技";
    [self addChildViewController:science];
    
}




#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    self.title = @"网易新闻";
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
 * 添加标题
 */
- (void)_setupTopicTitle
{
    // 定义临时变量
    CGFloat labelW = 100;
    CGFloat labelY = 0;
    CGFloat labelH = self.titlesView.frame.size.height;
    
    // 添加label
    NSInteger count = self.childViewControllers.count;
    for (NSInteger i = 0; i < count; i++) {
        MHTopicLabel *label = [[MHTopicLabel alloc] init];
        label.text = [self.childViewControllers[i] title];
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_labelClick:)]];
        label.tag = i;
        [self.titlesView addSubview:label];
        
        if (i == 0) { // 最前面的label
            label.scale = 1.0;
        }
    }
    
    // 设置contentSize
    self.titlesView.contentSize = CGSizeMake(count * labelW, 0);
    self.contentView.contentSize = CGSizeMake(count * [UIScreen mainScreen].bounds.size.width, 0);
    
}




/**
 * 设置顶部的标签栏
 */
- (void)_setupTitlesView
{
    // 标签栏整体
    UIScrollView *titlesView = [[UIScrollView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.mh_width = self.view.mh_width;
    titlesView.mh_height = MHTitilesViewH;
    titlesView.mh_y = MHTitilesViewY;
    titlesView.showsHorizontalScrollIndicator = NO;
    titlesView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 设置TopicTitle
    [self _setupTopicTitle];
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
    
    // 添加label
    NSInteger count = self.childViewControllers.count;
    self.contentView.contentSize = CGSizeMake(count * [UIScreen mainScreen].bounds.size.width, 0);
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}


/**
 * 监听顶部label点击
 */
- (void)_labelClick:(UITapGestureRecognizer *)tap
{
    // 取出被点击label的索引
    NSInteger index = tap.view.tag;
    
    // 让底部的内容scrollView滚动到对应位置
    CGPoint offset = self.contentView.contentOffset;
    offset.x = index * self.contentView.frame.size.width;
    [self.contentView setContentOffset:offset animated:YES];
}


#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    
}

#pragma mark - UIScrollViewDelegate
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 一些临时变量
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    MHTopicLabel *label = self.titlesView.subviews[index];
    CGPoint titleOffset = self.titlesView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titlesView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titlesView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (MHTopicLabel *otherLabel in self.titlesView.subviews) {
        if (otherLabel != label) otherLabel.scale = 0.0;
    }
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale > self.titlesView.subviews.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    MHTopicLabel *leftLabel = self.titlesView.subviews[leftIndex];
    
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    MHTopicLabel *rightLabel = (rightIndex == self.titlesView.subviews.count) ? nil : self.titlesView.subviews[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
}

@end
