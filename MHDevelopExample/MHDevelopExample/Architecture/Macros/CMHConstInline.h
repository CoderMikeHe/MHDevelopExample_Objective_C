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


/// 是否为空字典
static inline BOOL mh_isEmptyDictionary(id classObj){
    if ([classObj isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary*)classObj count] == 0;
    }
    return YES;
}

/// 是否为空数组
static inline BOOL mh_isEmptyArray(id classObj){
    if ([classObj isKindOfClass:[NSArray class]]){
        return [(NSArray*)classObj count] == 0;
    }
    return YES;
}

/// 是否为null对象
static inline BOOL mh_isNullObject(id objClass){
    if (!objClass || objClass == nil || [objClass isKindOfClass:[NSNull class]] || [[objClass class] isSubclassOfClass:[NSNull class]] || [objClass isEqual:[NSNull null]] || [objClass isEqual:NULL] || objClass == NULL || objClass == (id)kCFNull){
        return YES;
    }
    return NO;
}

/// 是否为空对象
static inline BOOL mh_isEmptyObject(id objClass){
    if (mh_isNullObject(objClass)){
        return YES;
    }
    if ([objClass respondsToSelector:@selector(length)]){
        return [objClass length] == 0;
    }
    if ([objClass isKindOfClass:[NSArray class]]){
        return [(NSArray*)objClass count] == 0;
    }
    if ([objClass isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary*)objClass count] == 0;
    }
    if ([objClass isKindOfClass:[NSSet class]]){
        return [(NSSet*)objClass count] == 0;
    }
    return NO;
}

/// 是否为空字符串
static inline BOOL mh_isEmptyString(NSString *string){
    if (mh_isNullObject(string) || ![string isKindOfClass:[NSString class]]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]== 0 || [[string lowercaseString] isEqual:@"null"] || [[string lowercaseString] isEqualToString:@"<null>"] || [[string lowercaseString] isEqualToString:@"(null)"]){
        return YES;
    }
    return NO;
}

/// 获取有效的字符串
static inline NSString * mh_getValidString(id value){
    if (value == nil || [value isKindOfClass:[NSNull class]]){
        return @"";
    }else if ([value isKindOfClass:[NSString class]]){
        return value;
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)value stringValue];
    }else{
        return [NSString stringWithFormat:@"%@", value];
    }
    return @"";
}

/// 获取去掉空格的有效的字符串
static inline NSString * mh_getValidDelSpaceString(id value){
    NSString *returnStr = nil;
    if (value == nil || [value isKindOfClass:[NSNull class]]){
        return @"";
    }else if ([value isKindOfClass:[NSString class]]){
        returnStr = value;
    }else if ([value isKindOfClass:[NSNumber class]]){
        returnStr = [(NSNumber*)value stringValue];
    }else{
        returnStr = [NSString stringWithFormat:@"%@", value];
    }
    
    if (returnStr.length > 0){
        returnStr = [returnStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        return returnStr;
    }
    return @"";
}

/// 获取有效的整形值
static inline NSInteger mh_getValidIntegerValue(id value){
    if ([value isKindOfClass:[NSString class]]){
        return [value integerValue];
    }else if ([value isKindOfClass:[NSNumber class]]){
        return [(NSNumber*)value integerValue];
    }else{
        return 0;
    }
    return 0;
}
#endif /* CMHConstInline_h */
