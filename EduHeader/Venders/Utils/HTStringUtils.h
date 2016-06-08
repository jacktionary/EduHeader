//
//  StringUtils.h
//  
//
//  Created by HaoKing on 14-2-11.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTDateType_Year=0,
    HTDateType_Hour,
} HTDateType;


@interface StringUtils : NSObject

+ (NSString *)getMD5:(NSString *)string;
+ (NSString *)UUID;
+ (NSString *)sha1:(NSString *)str;

+(NSString *)getNewDateWithString:(NSString *)dateString type:(HTDateType)dateType;

+(NSString *)getDateWithTimeStamp:(NSString *)timestamp;

+(NSString *)getDateWithFormatter:(NSString *)formatter andTimeStamp:(NSString *)timestamp;

@end
