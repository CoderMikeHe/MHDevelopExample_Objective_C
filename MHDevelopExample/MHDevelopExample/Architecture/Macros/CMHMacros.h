//
//  CMHMacros.h
//  MHDevelopExample
//
//  Created by lx on 2018/5/24.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#ifndef CMHMacros_h
#define CMHMacros_h


/// 1 -- 进入MVC设计模式        0 -- 进入开发Demo
#define CMHDEBUG 0



/// ---- WeChat --
/// 全局青色 tintColor
#define CMH_MAIN_TINTCOLOR [UIColor colorWithRed:(10 / 255.0) green:(193 / 255.0) blue:(42 / 255.0) alpha:1]



/// ---- YYWebImage Option
/// 手动设置image
#define MHWebImageOptionManually (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation|YYWebImageOptionAvoidSetImage)
/// 自动设置Image
#define MHWebImageOptionAutomatic (YYWebImageOptionAllowInvalidSSLCertificates|YYWebImageOptionAllowBackgroundTask|YYWebImageOptionSetImageWithFadeAnimation)



#import "CMHConstEnum.h"
#import "CMHConstInline.h"
#import "CMHConstant.h"
#endif /* CMHMacros_h */
