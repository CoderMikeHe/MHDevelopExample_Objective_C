//
//  UIBarButtonItem+MHExtension.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIBarButtonItem+MHExtension.h"
#import "MHBackButton.h"

@implementation UIBarButtonItem (MHExtension)


+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
     MHBackButton*button = [[MHBackButton alloc] init];
    
    if(imageName) [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(highImageName) [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 100, 44);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [UIBarButtonItem mh_itemWithImageName:imageName highImageName:nil target:target action:action];
}
@end
