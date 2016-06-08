//
//  StringUtils.m
//  
//
//  Created by HaoKing on 14-2-11.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import "HTStringUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation StringUtils

+(NSString *)getMD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
}

+(NSString *)getNewDateWithString:(NSString *)dateString type:(HTDateType)dateType{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:dateString];
    
    NSDateFormatter *yearOutputFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *hourOutputFormatter = [[NSDateFormatter alloc] init];
    [yearOutputFormatter setLocale:[NSLocale currentLocale]];
    [hourOutputFormatter setLocale:[NSLocale currentLocale]];
    [yearOutputFormatter setDateFormat:@"yyyy年MM月dd日 EE"];
    [hourOutputFormatter setDateFormat:@"HH:mm"];
    
    NSString * newdate = [[NSString alloc]init];
    if (dateType ==HTDateType_Year) {
        newdate = [yearOutputFormatter stringFromDate:inputDate];
    }else if(dateType == HTDateType_Hour){
        newdate = [hourOutputFormatter stringFromDate:inputDate];
    }
    return newdate;
}

+(NSString *)getDateWithTimeStamp:(NSString *)timestamp
{
    return [StringUtils getDateWithFormatter:@"yyyy-MM-dd" andTimeStamp:timestamp];
}

+(NSString *)getDateWithFormatter:(NSString *)formatter andTimeStamp:(NSString *)timestamp
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[timestamp doubleValue]/1000.0];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:formatter];
    
    NSString * newdate = [inputFormatter stringFromDate:date];
    
    return newdate;
}

+ (NSString *)UUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    NSLog(@"%@",result);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(NSString*) sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
