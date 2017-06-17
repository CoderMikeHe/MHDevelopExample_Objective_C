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
    NSLog(@"777777");
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         NSLog(@"888888");
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    NSLog(@"999999");
    return viewController;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (instancetype)initWithViewModel:(SUViewModel2 *)viewModel {
    self = [super init];
    if (self) {
        
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"444444");
    [super viewDidLoad];
    NSLog(@"555555");
}


// bind the viewModel
- (void)bindViewModel
{
    NSLog(@"666666");
    // set navgation title
    RAC(self , title) = RACObserve(self, viewModel.title);
    
    //
}









@end
