//
//  SUViewModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/12.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有自定义ViewModel的父类

#import <Foundation/Foundation.h>

@interface SUViewModel : NSObject
/// Initialization method. This is the preferred way to create a new view model.
///
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithParams:(NSDictionary *)params;



/// The `params` parameter in `-initWithParams:` method.
/// The `params` Key's `kBaseViewModelParamsKey`
@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, copy) NSString *title;

/// Request data from remote server
- (void)loadData:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure;

// ============== CoderMikeHe =================

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;
@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

/** should fetch local data when viewModel init . default is YES */
@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
/** should request data when viewController videwDidLoad . default is YES*/
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

/// An additional method, in which you can initialize data, RACCommand etc.
///
/// This method will be execute after the execution of `-initWithParams:` method. But
/// the premise is that you need to inherit `BaseViewModel`.
- (void)initialize;


// ============== CoderMikeHe =================


@end
