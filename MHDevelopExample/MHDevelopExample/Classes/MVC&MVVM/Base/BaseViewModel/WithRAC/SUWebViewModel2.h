//
//  SUWebViewModel2.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的控制器有WKWebView的所有自定义ViewModel的父类


#import "SUViewModel2.h"

@interface SUWebViewModel2 : SUViewModel2
/// web url 
@property (nonatomic, readwrite, copy) NSString *request;
@end
