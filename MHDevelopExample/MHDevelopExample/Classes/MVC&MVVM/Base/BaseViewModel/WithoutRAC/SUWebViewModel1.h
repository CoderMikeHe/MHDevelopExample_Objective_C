//
//  SUWebViewModel1.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/17.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的控制器有WKWebView的所有自定义ViewModel的父类

#import "SUViewModel1.h"

@interface SUWebViewModel1 : SUViewModel1

/// request
@property (nonatomic, readwrite, copy) NSString *request;

@end
