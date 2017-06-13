//
//  SUViewController.m
//  SenbaUsed
//
//  Created by senba on 2017/4/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUViewController.h"

@interface SUViewController ()

// viewModel
@property (nonatomic, readwrite, strong) SUViewModel *viewModel;

@end

@implementation SUViewController


// when `BaseViewController ` created and call `viewDidLoad` method , execute `bindViewModel` method
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    SUViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (instancetype)initWithViewModel:(SUViewModel *)viewModel {
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
    
    //
}









@end
