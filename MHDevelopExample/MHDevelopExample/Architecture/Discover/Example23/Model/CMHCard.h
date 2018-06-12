//
//  CMHCard.h
//  MHDevelopExample
//
//  Created by lx on 2018/6/12.
//  Copyright © 2018年 CoderMikeHe. All rights reserved.
//

#import "CMHObject.h"

@interface CMHCard : CMHObject
/// title
@property (nonatomic , readwrite , copy) NSString *title;
/// imageUrl
@property (nonatomic , readwrite , copy) NSString *imageUrl;
@end
