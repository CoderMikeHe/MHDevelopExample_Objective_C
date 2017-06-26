//
//  SUViewController2.m
//  SenbaUsed
//
//  Created by senba on 2017/4/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  MVVM With RAC 开发模式的所有自定义的控制器的父类

#import "SUViewController2.h"

@interface SUViewController2 ()

// viewModel
@property (nonatomic, readwrite, strong) SUViewModel2 *viewModel;

@end

@implementation SUViewController2

// when `BaseViewController ` created and call `viewDidLoad` method , execute `bindViewModel` method
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SUViewController2 *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}


- (instancetype)initWithViewModel:(SUViewModel2 *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


// bind the viewModel
- (void)bindViewModel
{
    // set navgation title
    RAC(self , title) = RACObserve(self, viewModel.title);
//    @weakify(self);
    [self.viewModel.errors subscribeNext:^(NSError *error) {
//        @strongify(self)
        NSLog(@"viewModel 的错误信息 -- %@" , error);
    }];
}

@end
