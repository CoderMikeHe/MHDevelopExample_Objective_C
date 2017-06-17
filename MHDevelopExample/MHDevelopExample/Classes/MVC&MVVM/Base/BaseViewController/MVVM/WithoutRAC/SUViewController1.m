//
//  SUViewController1.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/15.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM Without RAC 开发模式的所有自定义的控制器的父类

#import "SUViewController1.h"

@interface SUViewController1 ()
// viewModel
@property (nonatomic, readwrite, strong) SUViewModel1 *viewModel;
@end

@implementation SUViewController1

- (instancetype)initWithViewModel:(SUViewModel1 *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewModel.title;
}

@end
