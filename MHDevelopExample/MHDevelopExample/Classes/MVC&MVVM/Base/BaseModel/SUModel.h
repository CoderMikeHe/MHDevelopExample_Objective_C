//
//  SUModel.h
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//  所有自定义类的父类 -- M

#import <Foundation/Foundation.h>

@interface SUModel : NSObject<YYModel>

/**
 * 将 JSON (NSData,NSString,NSDictionary) 转换为 Model
 */
+ (instancetype)modelWithJSON:(id)json;
- (BOOL)modelSetWithJSON:(id)json;

/// 数组类包含该对象
+ (NSArray *)modelArrayWithJSON:(id)json;
/// Creates and returns a dictionary from a json.
+ (NSDictionary *)modelDictionaryWithJSON:(id)json;

/// 将 Model 转换为 JSON 对象
- (id)toJSONObject;
/// 将 Model 转换为 JSONData
- (NSData *)toJSONData;
/// 将 Model 转换为 JSONString
- (NSString *)toJSONString;

@end
