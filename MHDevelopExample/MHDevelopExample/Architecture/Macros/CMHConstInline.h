//
//  CMHConstInline.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/5.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#ifndef CMHConstInline_h
#define CMHConstInline_h

/// 适配 iPhone X 距离顶部的距离
static inline CGFloat CMHTopMargin(CGFloat pt){
    return MH_IS_IPHONE_X ? (pt + 24) : (pt);
}

/// 适配 iPhone X 距离底部的距离
static inline CGFloat CMHBottomMargin(CGFloat pt){
    return MH_IS_IPHONE_X ? (pt + 34) : (pt);
}

#endif /* CMHConstInline_h */
