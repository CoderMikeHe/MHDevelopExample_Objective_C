//
//  CMHHomePageViewController.m
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHHomePageViewController.h"
#import "CMHNavigationController.h"
#import "CMHMainFrameViewController.h"
#import "CMHContactsViewController.h"
#import "CMHDiscoverViewController.h"
#import "CMHProfileViewController.h"
@interface CMHHomePageViewController ()

@end

@implementation CMHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    /// 初始化所有的子控制器
    [self _setupAllChildViewController];
}


#pragma mark - 初始化所有的子视图控制器
- (void)_setupAllChildViewController{
    NSArray *titlesArray = @[@"微信", @"通讯录", @"发现", @"我"];
    NSArray *imageNamesArray = @[@"tabbar_mainframe_25x23",
                                 @"tabbar_contacts_27x23",
                                 @"tabbar_discover_23x23",
                                 @"tabbar_me_23x23"];
    NSArray *selectedImageNamesArray = @[@"tabbar_mainframeHL_25x23",
                                         @"tabbar_contactsHL_27x23",
                                         @"tabbar_discoverHL_23x23",
                                         @"tabbar_meHL_23x23"];
    
    /// 微信会话层
    UINavigationController *mainFrameNavigationController = ({
        CMHMainFrameViewController *mainFrameViewController = [[CMHMainFrameViewController alloc] initWithParams:nil];
        
        CMHTabBarItemTagType tagType = CMHTabBarItemTagTypeMainFrame;
        /// 配置
        [self _configViewController:mainFrameViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        /// 添加到导航栏的栈底控制器
        [[CMHNavigationController alloc] initWithRootViewController:mainFrameViewController];
    });
    
    /// 通讯录
    UINavigationController *contactsNavigationController = ({
        CMHContactsViewController *contactsViewController = [[CMHContactsViewController alloc] initWithParams:nil];
        
        CMHTabBarItemTagType tagType = CMHTabBarItemTagTypeContacts;
        /// 配置
        [self _configViewController:contactsViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[CMHNavigationController alloc] initWithRootViewController:contactsViewController];
    });
    
    /// 发现
    UINavigationController *discoverNavigationController = ({
        CMHDiscoverViewController *discoverViewController = [[CMHDiscoverViewController alloc] initWithParams:nil];
        
        CMHTabBarItemTagType tagType = CMHTabBarItemTagTypeDiscover;
        /// 配置
        [self _configViewController:discoverViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[CMHNavigationController alloc] initWithRootViewController:discoverViewController];
    });
    
    /// 我的
    UINavigationController *profileNavigationController = ({
        CMHProfileViewController *profileViewController = [[CMHProfileViewController alloc] initWithParams:nil];
        
        CMHTabBarItemTagType tagType = CMHTabBarItemTagTypeProfile;
        /// 配置
        [self _configViewController:profileViewController imageName:imageNamesArray[tagType] selectedImageName:selectedImageNamesArray[tagType] title:titlesArray[tagType] itemTag:tagType];
        
        [[CMHNavigationController alloc] initWithRootViewController:profileViewController];
    });
    
    /// 添加到tabBarController的子视图
    self.tabBarController.viewControllers = @[ mainFrameNavigationController, contactsNavigationController, discoverNavigationController, profileNavigationController ];
}

#pragma mark - 配置ViewController
- (void)_configViewController:(UIViewController *)viewController imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title itemTag:(CMHTabBarItemTagType)tagType {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.tag = tagType;
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = selectedImage;
    viewController.tabBarItem.title = title;
    
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#929292"),
                                 NSFontAttributeName:MHRegularFont_10};
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:MHColorFromHexString(@"#09AA07"),
                                   NSFontAttributeName:MHRegularFont_10};
    [viewController.tabBarItem setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 0)];
    [viewController.tabBarItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
