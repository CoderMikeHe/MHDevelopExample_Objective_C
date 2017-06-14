//
//  SUModel.m
//  MHDevelopExample
//
//  Created by senba on 2017/6/13.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "SUModel.h"

@implementation SUModel
/// 将 JSON (NSData,NSString,NSDictionary) 转换为 Model
+ (instancetype)modelWithJSON:(id)json { return [self yy_modelWithJSON:json]; }
- (BOOL)modelSetWithJSON:(id)json { return [self yy_modelSetWithJSON:json]; }


/// 数组类包含该对象
+ (NSArray *)modelArrayWithJSON:(id)json {
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
}
/// Creates and returns a dictionary from a json.
+ (NSDictionary *)modelDictionaryWithJSON:(id)json {
    return [NSDictionary yy_modelDictionaryWithClass:[self class] json:json];
}

- (id)toJSONObject { return [self yy_modelToJSONObject]; }
- (NSData *)toJSONData { return [self yy_modelToJSONData]; }
- (NSString *)toJSONString { return [self yy_modelToJSONString]; }



/// Coding/Copying/hash/equal
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }

/// Properties optional
- (void)setValue:(id)value forUndefinedKey:(NSString *)key { }

- (NSString *)description { return [self yy_modelDescription]; }


@end
