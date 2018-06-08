//
//  CMHConfigureView.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/4.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import <Foundation/Foundation.h>
/// A protocol which is adopted by views which are backed by models.
@protocol CMHConfigureView <NSObject>
@optional
/// Configure the given model to the view.
///
/// model - The model you want to  given to view
- (void)configureModel:(id)model;
@end
