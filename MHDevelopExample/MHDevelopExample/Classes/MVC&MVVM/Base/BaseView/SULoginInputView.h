//
//  SULoginInputView.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/11.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SULoginInputView : UIView

/// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


/// 验证码
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

+ (instancetype) inputView;

@end
