//
//  main.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/7.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#if defined(DEBUG)||defined(_DEBUG)
#import "FBAllocationTracker/FBAllocationTrackerManager.h"
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
#if defined(DEBUG)||defined(_DEBUG)
        [FBAssociationManager hook];
        [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
        [[FBAllocationTrackerManager sharedManager] enableGenerations];
#endif
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
