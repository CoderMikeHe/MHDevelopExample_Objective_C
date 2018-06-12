//
//  CMHNavigationController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/22.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHNavigationController.h"
#import "CMHViewController.h"
@interface CMHNavigationController ()
/// 导航栏分隔线
@property (nonatomic , weak , readwrite) UIImageView * navigationBottomLine;
@end

@implementation CMHNavigationController

// 第一次使用这个类调用一次
+ (void)initialize{
    
    // 2.设置UINavigationBar的主题
    [self _setupNavigationBarTheme];
    
    // 3.设置UIBarButtonItem的主题
    [self _setupBarButtonItemTheme];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // 初始化
    [self _setup];
}

#pragma mark - 初始化
- (void) _setup{
    /// 添加底部导航条
    [self _setupNavigationBarBottomLine];
}

// 查询最后一条数据
- (UIImageView *)_findHairlineImageViewUnder:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews){
        UIImageView *imageView = [self _findHairlineImageViewUnder:subview];
        if (imageView){ return imageView; }
    }
    return nil;
}

#pragma mark - 设置导航栏的分割线
- (void)_setupNavigationBarBottomLine{
    /// CoderMikeHe Fixed Bug : 这里直接设置系统的 navigationBarBottomLine.image = xxx;无效 Why？WTF？
    /// 隐藏了系统的 自己添加了一个分割线
    // 隐藏系统的导航栏分割线
    UIImageView *navigationBarBottomLine = [self _findHairlineImageViewUnder:self.navigationBar];
    navigationBarBottomLine.hidden = YES;
    // 添加自己的分割线
    CGFloat navSystemLineH = .5f;
    UIImageView *navSystemLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height - navSystemLineH, [UIScreen mainScreen].bounds.size.width, navSystemLineH)];
    /// CoderMikeHe Test : 搞个扎眼睛的颜色
    navSystemLine.backgroundColor = [UIColor redColor]; //[[UIColor blackColor] colorWithAlphaComponent:.1];
    [self.navigationBar addSubview:navSystemLine];
    self.navigationBottomLine = navSystemLine;
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void) _setupNavigationBarTheme{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    /// 设置背景
    //!!!: 必须设置为透明  不然布局有问题 ios8以下  会崩溃/ 如果iOS8以下  请再_setup里面 设置透明 self.navigationBar.translucent = YES;
    /// 必须设置YES
    [appearance setTranslucent:YES];
    
    // 设置导航栏的样式
    [appearance setBarStyle:UIBarStyleDefault];
    //设置导航栏文字按钮的渲染色
    [appearance setTintColor:[UIColor whiteColor]];
    // 设置导航栏的背景渲染色
    // 设置导航栏的背景渲染色
    CGFloat rgb = 0.1;
    [appearance setBarTintColor:[UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.65]];
    // 设置导航栏的背景渲染色或背景图片
    //    [appearance setBackgroundImage:[UIImage imageNamed:@"NavBackGround"] forBarMetrics:UIBarMetricsDefault];
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = MHMediumFont(18);
    textAttrs[NSForegroundColorAttributeName] = MHColorFromHexString(@"#FFFFFF");
    
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs];
    
    /// 去掉导航栏的阴影图片
    [appearance setShadowImage:[UIImage new]];
    
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)_setupBarButtonItemTheme{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    ///
    CGFloat fontSize = 14.0f;
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = MHColorFromHexString(@"#FFFFFF");
    textAttrs[NSFontAttributeName] = MHRegularFont(fontSize);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset =  CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [MHColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [MHColorFromHexString(@"#FFFFFF") colorWithAlphaComponent:.5f];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}


#pragma mark - Publi Method
/// 显示导航栏的细线
- (void)showNavigationBottomLine { self.navigationBottomLine.hidden = NO; }
/// 隐藏导航栏的细线
- (void)hideNavigationBottomLine { self.navigationBottomLine.hidden = YES; }




#pragma mark - 事件处理
- (void)_backItemDidClicked{ /// 回去
    [self popViewControllerAnimated:YES];
}

#pragma mark - Override
/// 能拦截所有push进来的子控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0){
        /// 记录snapView
        CMHViewController *topViewController = (CMHViewController *)[self topViewController];
        if (topViewController.tabBarController) {
            topViewController.snapshot = [topViewController.tabBarController.view snapshotViewAfterScreenUpdates:NO];
        } else {
            topViewController.snapshot = [self.view snapshotViewAfterScreenUpdates:NO];
        }
        /// 统一隐藏底部tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        /// CoderMikeHe Fixed Bug: 隐藏掉系统的返回按钮，这种方法会导致, 侧滑返回取消，导航栏会 莫名显示三个蓝点，及其恶心。但是如果不隐藏返回按钮，则会出现，你在viewController里面设置其 navigationItem.leftBarButtonItem = nil; 就会显示出系统的返回按钮。当然，出现蓝点的解决方案，在CMHViewController.m 里面，欢迎大家踊跃讨论
        viewController.navigationItem.backBarButtonItem = nil;
        [viewController.navigationItem setHidesBackButton:YES];
        
        // 4.这里可以设置导航栏的左右按钮 统一管理方法
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem mh_backItemWithTitle:@"返回" imageName:@"barbuttonicon_back_15x30" target:self action:@selector(_backItemDidClicked)];
    }
    
    // push
    [super pushViewController:viewController animated:animated];
}


- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.topViewController.prefersStatusBarHidden;
}
@end
