//
//  JsonBaseModel.m
//  康吴康
//
//  Created by 龚杰洪 on 14/12/26.
//  Copyright (c) 2014年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"
#import <objc/runtime.h>
#import "YYClassInfo.h"

@implementation JsonBaseModel

- (void)updateWithDictionary:(NSDictionary *)jsonDic
{
    [self setValuesForKeysWithDictionary:jsonDic];
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for ( i=0; i < propertyCount; i++ )
    {
        objc_property_t *thisProperty = propertyList + i;
        
        const char* propertyName = property_getName(*thisProperty);
        
        NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
        
        if ([[jsonDic objectForKey:propertyKeyName] isKindOfClass:[NSDictionary class]])
        {
            id object = [[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:[jsonDic objectForKey:propertyKeyName]];
            [self setValue:object forKey:propertyKeyName];
        }
        else if ([[jsonDic objectForKey:propertyKeyName] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *arr = [NSMutableArray array];
            for (id object in [jsonDic objectForKey:propertyKeyName])
            {
                if ([object isKindOfClass:[NSDictionary class]])
                {
                    [arr addObject:[[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:object]];
                }
                else
                {
                    [arr addObject:object];
                }
            }
            [self setValue:arr forKey:propertyKeyName];
        }
//        else if ([jsonDic objectForKey:propertyKeyName] == nil || [jsonDic objectForKey:propertyKeyName] == [NSNull null])
//        {
//            [self setValue:@"" forKey:propertyKeyName];
//        }
        else {
            
        }
    }
    free(propertyList);
}

- (id)initWithDictionary:(NSDictionary *)jsonDic
{
    self = [super init];
    
    if (self != nil)
    {
        [self setValuesForKeysWithDictionary:jsonDic];
        int i;
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
        
        for ( i=0; i < propertyCount; i++ )
        {
            objc_property_t *thisProperty = propertyList + i;
            
            const char* propertyName = property_getName(*thisProperty);
            
            NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
            
            if ([[jsonDic objectForKey:propertyKeyName] isKindOfClass:[NSDictionary class]])
            {
                id object = [[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:[jsonDic objectForKey:propertyKeyName]];
                [self setValue:object forKey:propertyKeyName];
            }
            else if ([[jsonDic objectForKey:propertyKeyName] isKindOfClass:[NSArray class]])
            {
                NSMutableArray *arr = [NSMutableArray array];
                for (id object in [jsonDic objectForKey:propertyKeyName])
                {
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        [arr addObject:[[[self getItemClassWithPropretyName:propertyKeyName] alloc] initWithDictionary:object]];
                    }
                    else
                    {
                        [arr addObject:object];
                    }
                }
                [self setValue:arr forKey:propertyKeyName];
            }
            else
            {
                YYClassPropertyInfo *info = [[YYClassPropertyInfo alloc] initWithProperty:*thisProperty];
                if (info)
                {
                    if ([self valueForKey:propertyKeyName] == nil || [self valueForKey:propertyKeyName] == [NSNull null])
                    {
                        [self setValue: [[info.cls alloc] init] forKey: propertyKeyName];
                    }
                    else
                    {
                        if ([[self valueForKey:propertyKeyName] isKindOfClass:info.cls])
                        {
                        }
                        else
                        {
                            if ([[self valueForKey:propertyKeyName] isKindOfClass:[NSNumber class]])
                            {
                                if (info.cls == nil)
                                {
                                    
                                }
                                else
                                {
                                    [self setValue: [NSString stringWithFormat:@"%ld", [[self valueForKey:propertyKeyName] integerValue]] forKey: propertyKeyName];
                                }
                            }
                            else
                            {
                            }
                        }
                    }
                }
            }
        }
        free(propertyList);
    }
    return self;
}

-(Class)getItemClassWithPropretyName:(NSString *)name
{
    return [NSString class];
}

- (id)initWithCacheKey:(NSString *)cacheKey
{
    self = [super init];
    
    if (self != nil)
    {
        return [self initWithDictionary:[[NSUserDefaults standardUserDefaults]
                                  valueForKey:cacheKey]];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"\n\nUndefined Key : %@\n\n", key);
}

- (NSDictionary *)convertToDictionary
{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    for ( i=0; i < propertyCount; i++ )
    {
        objc_property_t *thisProperty = propertyList + i;
        
        const char* propertyName = property_getName(*thisProperty);
        
        NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
        
        if ([[self valueForKey:propertyKeyName] isKindOfClass:[JsonBaseModel class]])
        {
            [returnDic setValue:[[self valueForKey:propertyKeyName] convertToDictionary] forKey:propertyKeyName];
        }
        else if ([[self valueForKey:propertyKeyName] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *arr = [NSMutableArray array];
            for (id object in [self valueForKey:propertyKeyName])
            {
                if ([object isKindOfClass:[NSArray class]])
                {
                    [arr addObject:[object convertToDictionary]];
                }
                else if ([object isKindOfClass:[JsonBaseModel class]])
                {
                    [arr addObject:[object convertToDictionary]];
                }
                else {
                    [arr addObject:object];
                }
            }
            [returnDic setValue:arr forKey:propertyKeyName];
        }
        else
        {
            [returnDic setValue:[self valueForKey:propertyKeyName]?
             [self valueForKey:propertyKeyName] : @""
                         forKey:propertyKeyName];
        }
    }
    free(propertyList);
    return returnDic;
}

- (BOOL)cacheWithCacheKey:(NSString *)cacheKey
{
    [[NSUserDefaults standardUserDefaults] setObject:self.convertToDictionary
                                              forKey:cacheKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for ( i=0; i < propertyCount; i++ )
    {
        objc_property_t *thisProperty = propertyList + i;
        
        const char* propertyName = property_getName(*thisProperty);
        
        NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
        [self setValue:[decoder decodeObjectForKey: propertyKeyName] forKey:propertyKeyName];
    }
    free(propertyList);
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    for ( i=0; i < propertyCount; i++ )
    {
        objc_property_t *thisProperty = propertyList + i;
        
        const char* propertyName = property_getName(*thisProperty);
        
        NSString *propertyKeyName = [NSString stringWithUTF8String:propertyName];
        [aCoder encodeObject:[self valueForKey:propertyKeyName] forKey:propertyKeyName];
    }
    free(propertyList);
}

@end
