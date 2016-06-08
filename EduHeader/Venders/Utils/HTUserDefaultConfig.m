//
//  HTUserDefaultConfig.m
//  
//
//  Created by HaoKing on 14-3-11.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import "HTUserDefaultConfig.h"

#define HTKEY_PRE @"HT_KEY"

@implementation HTUserDefaultConfig

+ (void)setKey:(NSString *)key forValue:(id)value
{
    NSString *HT_key = [NSString stringWithFormat:@"%@_%@", HTKEY_PRE, key];
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:HT_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValueForKey:(NSString *)key
{
    NSString *HT_key = [NSString stringWithFormat:@"%@_%@", HTKEY_PRE, key];
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:HT_key];
}

+ (id)getValueForKey:(NSString *)key defaultValue:(id)defaultValue
{
    id value = [HTUserDefaultConfig getValueForKey:key];
    
    if (!value) {
        value = defaultValue;
    }
    
    return value;
}

@end
