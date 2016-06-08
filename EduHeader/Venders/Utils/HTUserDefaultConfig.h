//
//  HTUserDefaultConfig.h
//  
//
//  Created by HaoKing on 14-3-11.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUserDefaultConfig : NSObject

+ (void)setKey:(NSString *)key forValue:(id)value;
+ (id)getValueForKey:(NSString *)key;
+ (id)getValueForKey:(NSString *)key defaultValue:(id)defaultValue;

@end
